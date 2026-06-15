variable "project" {
  description = "Nombre del proyecto"
  type        = string
}

variable "environment" {
  description = "Ambiente (dev, staging, prod)"
  type        = string
}

variable "instance_type" {
  description = "Tipo de instancia EC2 (t3.micro está en Free Tier)"
  type        = string
  default     = "t3.micro"
}

variable "subnet_id" {
  description = "ID de la subnet pública donde se desplegará EC2"
  type        = string
}

variable "security_group_id" {
  description = "ID del security group para EC2"
  type        = string
}

variable "ssh_public_key" {
  description = "Contenido de la clave pública SSH"
  type        = string
  sensitive   = true
}
