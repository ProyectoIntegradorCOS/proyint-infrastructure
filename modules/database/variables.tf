variable "project" {
  description = "Nombre del proyecto"
  type        = string
}

variable "environment" {
  description = "Ambiente (dev, staging, prod)"
  type        = string
}

variable "instance_class" {
  description = "Clase de instancia RDS (db.t3.micro está en Free Tier)"
  type        = string
  default     = "db.t3.micro"
}

variable "allocated_storage" {
  description = "Almacenamiento en GB (Free Tier: hasta 20 GB)"
  type        = number
  default     = 20
}

variable "db_name" {
  description = "Nombre de la base de datos"
  type        = string
  default     = "thaqhiri"
}

variable "db_username" {
  description = "Usuario master de la BD"
  type        = string
  sensitive   = true
}

variable "db_password" {
  description = "Contraseña del usuario master"
  type        = string
  sensitive   = true
}

variable "subnet_ids" {
  description = "IDs de subnets privadas para el DB subnet group"
  type        = list(string)
}

variable "security_group_id" {
  description = "ID del security group para RDS"
  type        = string
}

variable "skip_final_snapshot" {
  description = "Omitir snapshot final al destruir (true en dev)"
  type        = bool
  default     = true
}

variable "deletion_protection" {
  description = "Protección contra borrado accidental (true en prod)"
  type        = bool
  default     = false
}

variable "backup_retention_period" {
  description = "Días de retención de backups"
  type        = number
  default     = 7
}
