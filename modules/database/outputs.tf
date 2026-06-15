output "endpoint" {
  description = "Endpoint de conexión RDS (host:port)"
  value       = aws_db_instance.main.endpoint
}

output "host" {
  description = "Hostname del RDS (sin puerto)"
  value       = aws_db_instance.main.address
}

output "db_name" {
  description = "Nombre de la base de datos"
  value       = aws_db_instance.main.db_name
}

output "port" {
  description = "Puerto PostgreSQL"
  value       = aws_db_instance.main.port
}
