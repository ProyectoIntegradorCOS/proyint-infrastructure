output "ec2_public_ip" {
  description = "IP pública del servidor de aplicación"
  value       = module.compute.public_ip
}

output "rds_endpoint" {
  description = "Endpoint RDS para configurar en el backend"
  value       = module.database.endpoint
  sensitive   = true
}

output "rds_host" {
  description = "Host RDS (sin puerto)"
  value       = module.database.host
  sensitive   = true
}

output "s3_frontend_bucket" {
  description = "Nombre del bucket S3 para el frontend Angular"
  value       = module.storage.frontend_bucket_name
}

output "s3_apk_bucket" {
  description = "Nombre del bucket S3 para distribución de APKs"
  value       = module.storage.apk_bucket_name
}

output "vpc_id" {
  value = module.network.vpc_id
}

# ── ECR / GitHub Actions ──────────────────────────────────────────────────────
# Copia estos valores como secrets en el repositorio de GitHub Actions de la app:
#   AWS_ROLE_ARN       → ecr_github_actions_role_arn
#   ECR_REGISTRY       → ecr_registry_url
#   ECR_REPOSITORY     → ecr_repository_name

output "ecr_repository_url" {
  description = "URL completa del repositorio ECR (para docker push/pull)"
  value       = module.ecr.repository_url
}

output "ecr_registry_url" {
  description = "URL del registro ECR — secret ECR_REGISTRY en GitHub Actions"
  value       = module.ecr.registry_url
}

output "ecr_repository_name" {
  description = "Nombre del repositorio ECR — secret ECR_REPOSITORY en GitHub Actions"
  value       = module.ecr.repository_name
}

output "ecr_github_actions_role_arn" {
  description = "ARN del IAM Role — secret AWS_ROLE_ARN en GitHub Actions"
  value       = module.ecr.github_actions_role_arn
}
