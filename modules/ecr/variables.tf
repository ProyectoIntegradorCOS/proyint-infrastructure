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

variable "github_repos" {
  description = "Lista de repositorios GitHub autorizados para asumir este rol (ej: [\"proyint-backend\", \"proyint-infrastructure\"])"
  type        = list(string)
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

variable "tfstate_bucket" {
  description = "Nombre del bucket S3 donde se guarda el Terraform state"
  type        = string
}

variable "tfstate_dynamodb_table" {
  description = "Nombre de la tabla DynamoDB para los locks de Terraform"
  type        = string
}
