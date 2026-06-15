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

output "s3_bucket" {
  description = "Nombre del bucket S3 para APKs"
  value       = module.storage.bucket_name
}

output "vpc_id" {
  value = module.network.vpc_id
}
