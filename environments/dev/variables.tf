variable "aws_region" {
  description = "Región AWS"
  type        = string
  default     = "us-west-2"
}

variable "project" {
  description = "Nombre del proyecto"
  type        = string
  default     = "thaqhiri"
}

variable "environment" {
  description = "Nombre del ambiente"
  type        = string
  default     = "dev"
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  type    = list(string)
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  type    = list(string)
  default = ["10.0.10.0/24", "10.0.20.0/24"]
}

variable "availability_zones" {
  type    = list(string)
  default = ["us-west-2a", "us-west-2b"]
}

variable "ssh_allowed_cidrs" {
  description = "Restringe SSH a tu IP: [\"TU_IP/32\"]"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "ec2_instance_type" {
  description = "t3.micro es Free Tier en us-west-2"
  type        = string
  default     = "t3.micro"
}

variable "rds_instance_class" {
  description = "db.t3.micro es Free Tier"
  type        = string
  default     = "db.t3.micro"
}

variable "rds_allocated_storage" {
  description = "Hasta 20 GB en Free Tier"
  type        = number
  default     = 20
}

variable "db_name" {
  type    = string
  default = "thaqhiri"
}

# Sensibles: pasar por -var o variable de entorno TF_VAR_*
variable "db_username" {
  type      = string
  sensitive = true
}

variable "db_password" {
  type      = string
  sensitive = true
}

variable "ssh_public_key" {
  description = "Contenido de tu clave pública (~/.ssh/id_rsa.pub)"
  type        = string
  sensitive   = true
}

variable "bucket_suffix" {
  description = "Sufijo único — usa tu AWS Account ID (12 dígitos)"
  type        = string
}

variable "github_org" {
  description = "Usuario u organización de GitHub (ej: carlosormeno)"
  type        = string
}

variable "github_repo" {
  description = "Nombre del repositorio de la app en GitHub (ej: proyint-app)"
  type        = string
}
