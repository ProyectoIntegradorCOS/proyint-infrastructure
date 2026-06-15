output "ec2_public_ip" { value = module.compute.public_ip }
output "rds_endpoint"  { value = module.database.endpoint; sensitive = true }
output "s3_bucket"     { value = module.storage.bucket_name }
