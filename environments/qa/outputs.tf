output "ec2_public_ip" { value = module.compute.public_ip }
output "rds_endpoint"  { value = module.database.endpoint; sensitive = true }
output "s3_bucket"     { value = module.storage.bucket_name }

output "ecr_repository_url"        { value = module.ecr.repository_url }
output "ecr_registry_url"          { value = module.ecr.registry_url }
output "ecr_repository_name"       { value = module.ecr.repository_name }
output "ecr_github_actions_role_arn" { value = module.ecr.github_actions_role_arn }
