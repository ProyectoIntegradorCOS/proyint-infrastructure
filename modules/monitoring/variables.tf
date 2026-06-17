variable "project" {
  description = "Nombre del proyecto"
  type        = string
}

variable "environment" {
  description = "Ambiente (dev, staging, prod)"
  type        = string
}

variable "instance_type" {
  description = "Tipo de instancia EC2 para las instancias de monitoreo"
  type        = string
  default     = "t3.micro"
}

variable "subnet_id" {
  description = "ID de la subnet pública donde se desplegarán las instancias"
  type        = string
}

variable "vpc_id" {
  description = "ID de la VPC"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR de la VPC — permite tráfico interno entre instancias"
  type        = string
}

variable "sg_app_id" {
  description = "ID del security group de la instancia app — se le agrega regla para node_exporter"
  type        = string
}

variable "key_name" {
  description = "Nombre del key pair existente para acceso SSH"
  type        = string
}

variable "ssh_allowed_cidrs" {
  description = "CIDRs con acceso SSH a las instancias de monitoreo"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "monitoring_allowed_cidrs" {
  description = "CIDRs con acceso a los puertos de monitoreo (Prometheus, Grafana, Loki, Jaeger)"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}
