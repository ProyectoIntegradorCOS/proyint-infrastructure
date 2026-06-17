output "monitoring_core_public_ip" {
  description = "IP pública (EIP) de la instancia monitoring-core"
  value       = aws_eip.monitoring_core.public_ip
}

output "monitoring_core_private_ip" {
  description = "IP privada de la instancia monitoring-core"
  value       = aws_instance.monitoring_core.private_ip
}

output "monitoring_logs_public_ip" {
  description = "IP pública (EIP) de la instancia monitoring-logs"
  value       = aws_eip.monitoring_logs.public_ip
}

output "monitoring_logs_private_ip" {
  description = "IP privada de la instancia monitoring-logs"
  value       = aws_instance.monitoring_logs.private_ip
}

output "sg_monitoring_core_id" {
  description = "ID del security group de monitoring-core"
  value       = aws_security_group.monitoring_core.id
}

output "sg_monitoring_logs_id" {
  description = "ID del security group de monitoring-logs"
  value       = aws_security_group.monitoring_logs.id
}
