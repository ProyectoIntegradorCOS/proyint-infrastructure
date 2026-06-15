variable "project" {
  description = "Nombre del proyecto"
  type        = string
}

variable "environment" {
  description = "Ambiente (dev, staging, prod)"
  type        = string
}

variable "bucket_suffix" {
  description = "Sufijo único para el nombre del bucket (usa tu AWS Account ID)"
  type        = string
}
