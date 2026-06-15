variable "project" {
  description = "Nombre del proyecto"
  type        = string
}

variable "environment" {
  description = "Ambiente (dev, staging, prod)"
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

variable "create_oidc_provider" {
  description = "Crear el OIDC provider de GitHub. Solo true en el primer ambiente aplicado (dev). En qa y prod usar false."
  type        = bool
  default     = true
}

variable "max_image_count" {
  description = "Número máximo de imágenes a retener en ECR antes de expirar las más antiguas"
  type        = number
  default     = 5
}
