output "vpc_id" {
  description = "ID de la VPC"
  value       = aws_vpc.main.id
}

output "public_subnet_ids" {
  description = "IDs de las subnets públicas"
  value       = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  description = "IDs de las subnets privadas"
  value       = aws_subnet.private[*].id
}

output "sg_ec2_id" {
  description = "ID del security group de EC2"
  value       = aws_security_group.ec2.id
}

output "sg_rds_id" {
  description = "ID del security group de RDS"
  value       = aws_security_group.rds.id
}
