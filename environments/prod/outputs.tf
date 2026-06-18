output "ec2_public_ip" { value = module.compute.public_ip }
output "rds_endpoint" {
  value     = "thaqhiri-qa-db.c5yeysa8c27n.us-west-2.rds.amazonaws.com:5432"
  sensitive = true
}
output "s3_frontend_bucket" { value = module.storage.frontend_bucket_name }
output "s3_apk_bucket"     { value = module.storage.apk_bucket_name }

output "ecr_repository_url"        { value = module.ecr.repository_url }
output "ecr_registry_url"          { value = module.ecr.registry_url }
output "ecr_repository_name"       { value = module.ecr.repository_name }
output "ecr_github_actions_role_arn" { value = module.ecr.github_actions_role_arn }
