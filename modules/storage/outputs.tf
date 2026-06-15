output "frontend_bucket_name" {
  description = "Nombre del bucket S3 para el frontend Angular"
  value       = aws_s3_bucket.frontend.bucket
}

output "frontend_bucket_arn" {
  description = "ARN del bucket S3 para el frontend Angular"
  value       = aws_s3_bucket.frontend.arn
}

output "apk_bucket_name" {
  description = "Nombre del bucket S3 para distribución de APKs"
  value       = aws_s3_bucket.apk.bucket
}

output "apk_bucket_arn" {
  description = "ARN del bucket S3 para distribución de APKs"
  value       = aws_s3_bucket.apk.arn
}
