locals {
  name_prefix = "${var.project}-${var.environment}"
}

# ── Bucket frontend (Angular build) ──────────────────────────────────────────

resource "aws_s3_bucket" "frontend" {
  bucket = "${local.name_prefix}-frontend-${var.bucket_suffix}"

  tags = {
    Name        = "${local.name_prefix}-frontend"
    Project     = var.project
    Environment = var.environment
  }
}

resource "aws_s3_bucket_versioning" "frontend" {
  bucket = aws_s3_bucket.frontend.id
  versioning_configuration { status = "Enabled" }
}

resource "aws_s3_bucket_public_access_block" "frontend" {
  bucket                  = aws_s3_bucket.frontend.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# ── Bucket APK (distribución móvil) ──────────────────────────────────────────

resource "aws_s3_bucket" "apk" {
  bucket = "${local.name_prefix}-apk-${var.bucket_suffix}"

  tags = {
    Name        = "${local.name_prefix}-apk"
    Project     = var.project
    Environment = var.environment
  }
}

resource "aws_s3_bucket_versioning" "apk" {
  bucket = aws_s3_bucket.apk.id
  versioning_configuration { status = "Enabled" }
}

resource "aws_s3_bucket_public_access_block" "apk" {
  bucket                  = aws_s3_bucket.apk.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
