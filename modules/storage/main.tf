locals {
  name_prefix = "${var.project}-${var.environment}"
}

# S3 para distribución de APKs y assets estáticos
resource "aws_s3_bucket" "assets" {
  # Nombre único global: project-env-assets-sufijo
  bucket = "${local.name_prefix}-assets-${var.bucket_suffix}"

  tags = {
    Name        = "${local.name_prefix}-assets"
    Project     = var.project
    Environment = var.environment
  }
}

resource "aws_s3_bucket_versioning" "assets" {
  bucket = aws_s3_bucket.assets.id

  versioning_configuration {
    status = "Enabled"
  }
}

# Bloquea todo acceso público (los APKs se descargan via URL firmada o desde EC2)
resource "aws_s3_bucket_public_access_block" "assets" {
  bucket = aws_s3_bucket.assets.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
