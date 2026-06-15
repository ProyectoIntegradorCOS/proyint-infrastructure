output "instance_id" {
  description = "ID de la instancia EC2"
  value       = aws_instance.app.id
}

output "public_ip" {
  description = "IP pública (Elastic IP) del servidor"
  value       = aws_eip.app.public_ip
}

output "private_ip" {
  description = "IP privada del servidor"
  value       = aws_instance.app.private_ip
}
