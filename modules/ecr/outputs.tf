output "repository_url" {
  description = "URL completa del repositorio — usar en: docker push <repository_url>:<tag>"
  value       = aws_ecr_repository.app.repository_url
}

output "repository_name" {
  description = "Nombre del repositorio ECR"
  value       = aws_ecr_repository.app.name
}

output "repository_arn" {
  description = "ARN del repositorio ECR"
  value       = aws_ecr_repository.app.arn
}

output "registry_url" {
  description = "URL del registro ECR — usar en: aws ecr get-login-password | docker login <registry_url>"
  value       = "${data.aws_caller_identity.current.account_id}.dkr.ecr.${data.aws_region.current.name}.amazonaws.com"
}

output "github_actions_role_arn" {
  description = "ARN del IAM Role — configurar como secret AWS_ROLE_ARN en el repositorio de GitHub Actions"
  value       = aws_iam_role.github_actions.arn
}
