locals {
  name_prefix = "${var.project}-${var.environment}"
}

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

# ── Repositorio ECR ───────────────────────────────────────────────────────────

resource "aws_ecr_repository" "app" {
  name                 = local.name_prefix
  image_tag_mutability = "MUTABLE"
  force_delete         = true

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name        = local.name_prefix
    Project     = var.project
    Environment = var.environment
  }
}

resource "aws_ecr_lifecycle_policy" "app" {
  repository = aws_ecr_repository.app.name

  policy = jsonencode({
    rules = [{
      rulePriority = 1
      description  = "Retener solo las últimas ${var.max_image_count} imágenes"
      selection = {
        tagStatus   = "any"
        countType   = "imageCountMoreThan"
        countNumber = var.max_image_count
      }
      action = { type = "expire" }
    }]
  })
}

# ── OIDC Provider para GitHub Actions ────────────────────────────────────────
# El OIDC provider es único por cuenta AWS. Crealo una sola vez (dev).
# En qa y prod setea create_oidc_provider = false para referenciar el existente.

resource "aws_iam_openid_connect_provider" "github" {
  count = var.create_oidc_provider ? 1 : 0

  url             = "https://token.actions.githubusercontent.com"
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = ["6938fd4d98bab03faadb97b34396831e3780aea1", "1c58a3a8518e8759bf075b76b750d4f2df264fcd"]
}

data "aws_iam_openid_connect_provider" "github" {
  count = var.create_oidc_provider ? 0 : 1
  url   = "https://token.actions.githubusercontent.com"
}

locals {
  github_oidc_arn = coalesce(
    one(aws_iam_openid_connect_provider.github[*].arn),
    one(data.aws_iam_openid_connect_provider.github[*].arn)
  )
}

# ── IAM Role para GitHub Actions (push a ECR) ────────────────────────────────

resource "aws_iam_role" "github_actions" {
  name = "${local.name_prefix}-gha-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Federated = local.github_oidc_arn }
      Action    = "sts:AssumeRoleWithWebIdentity"
      Condition = {
        StringEquals = {
          "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"
        }
        # Restringe el acceso al repo específico de la app
        StringLike = {
          "token.actions.githubusercontent.com:sub" = [
            for repo in var.github_repos : "repo:${var.github_org}/${repo}:*"
          ]
        }
      }
    }]
  })

  tags = {
    Name        = "${local.name_prefix}-gha-role"
    Project     = var.project
    Environment = var.environment
  }
}

resource "aws_iam_policy" "ecr_push" {
  name        = "${local.name_prefix}-ecr-push"
  description = "Permisos de push para GitHub Actions → ECR ${local.name_prefix}"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        # Login al registro (aplica a toda la cuenta, no se puede restringir por repo)
        Sid      = "ECRLogin"
        Effect   = "Allow"
        Action   = ["ecr:GetAuthorizationToken"]
        Resource = "*"
      },
      {
        Sid    = "ECRPush"
        Effect = "Allow"
        Action = [
          "ecr:BatchCheckLayerAvailability",
          "ecr:CompleteLayerUpload",
          "ecr:InitiateLayerUpload",
          "ecr:PutImage",
          "ecr:UploadLayerPart",
          "ecr:BatchGetImage",
          "ecr:GetDownloadUrlForLayer",
          "ecr:DescribeRepositories",
          "ecr:ListImages"
        ]
        Resource = aws_ecr_repository.app.arn
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "github_actions_ecr" {
  role       = aws_iam_role.github_actions.name
  policy_arn = aws_iam_policy.ecr_push.arn
}

# AdministratorAccess permite a Terraform gestionar todos los recursos de la infra.
# El riesgo está acotado: el rol solo puede ser asumido desde los repos OIDC declarados.
resource "aws_iam_role_policy_attachment" "github_actions_admin" {
  role       = aws_iam_role.github_actions.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

# ── IAM Policy para Terraform backend (S3 + DynamoDB) ────────────────────────

resource "aws_iam_policy" "terraform_state" {
  name        = "${local.name_prefix}-terraform-state"
  description = "Permite a GitHub Actions leer/escribir el Terraform state en S3 y DynamoDB"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "S3StateList"
        Effect = "Allow"
        Action = ["s3:ListBucket"]
        Resource = "arn:aws:s3:::${var.tfstate_bucket}"
      },
      {
        Sid    = "S3StateReadWrite"
        Effect = "Allow"
        Action = ["s3:GetObject", "s3:PutObject", "s3:DeleteObject"]
        Resource = "arn:aws:s3:::${var.tfstate_bucket}/*"
      },
      {
        Sid    = "DynamoDBLock"
        Effect = "Allow"
        Action = [
          "dynamodb:DescribeTable",
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:DeleteItem"
        ]
        Resource = "arn:aws:dynamodb:*:${data.aws_caller_identity.current.account_id}:table/${var.tfstate_dynamodb_table}"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "github_actions_state" {
  role       = aws_iam_role.github_actions.name
  policy_arn = aws_iam_policy.terraform_state.arn
}
