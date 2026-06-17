# ──────────────────────────────────────────────────────────────────────────────
# Variables NO sensibles del ambiente dev
# Los valores sensibles (db_username, db_password, ssh_public_key) NO van aquí:
# pásalos con:
#   export TF_VAR_db_username="admindmcfinal"
#   export TF_VAR_db_password="AdminDMC123"
#   export TF_VAR_ssh_public_key="$(cat ~/.ssh/id_rsa.pub)"
# ──────────────────────────────────────────────────────────────────────────────

aws_region   = "us-west-2"
project      = "thaqhiri"
environment  = "dev"

# Red
vpc_cidr             = "10.0.0.0/16"
public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnet_cidrs = ["10.0.10.0/24", "10.0.20.0/24"]
availability_zones   = ["us-west-2a", "us-west-2b"]

# Restringe SSH solo a tu IP (recomendado): "TU_IP_PUBLICA/32"
ssh_allowed_cidrs = ["0.0.0.0/0"]

# Cómputo (Free Tier)
ec2_instance_type        = "t3.micro"
monitoring_instance_type = "t3.micro"

# Monitoreo: acceso a Prometheus, Grafana, Alertmanager, Loki y Jaeger
monitoring_allowed_cidrs = ["81.27.86.105/32", "181.224.233.39/32"]

# Base de datos (Free Tier)
rds_instance_class    = "db.t3.micro"
rds_allocated_storage = 20
db_name               = "thaqhiri"

# S3: reemplaza con tu AWS Account ID (12 dígitos, sin guiones)
bucket_suffix = "023894313590"

# ECR + GitHub Actions OIDC
github_org   = "ProyectoIntegradorCOS"
github_repos = ["proyint-backend", "proyint-infrastructure", "proyint-frontend", "proyint-mobile"]
