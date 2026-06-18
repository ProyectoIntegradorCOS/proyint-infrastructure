# proyint-infrastructure

Infraestructura como código (IaC) del proyecto **THAQHIRI** — sistema de georreferenciación de la Oficina de Normalización Previsional (ONP). Gestiona todos los recursos AWS mediante Terraform con arquitectura multi-ambiente.

## Tecnologías

- **Terraform** 1.7.0
- **AWS** (EC2, RDS PostgreSQL, S3, ECR, IAM)
- **GitHub Actions** con autenticación OIDC (sin credenciales estáticas)

## Ambientes

| Ambiente | VPC | EC2 Backend | RDS |
|---|---|---|---|
| dev | 10.0.0.0/16 | 44.237.58.16 | thaqhiri-dev-db |
| qa | 10.1.0.0/16 | 44.245.108.123 | thaqhiri-qa-db (público) |
| prod | 10.2.0.0/16 | 44.238.218.85 | Compartido con QA (Free Tier) |

## Estructura

```
proyint-infrastructure/
├── environments/
│   ├── dev/
│   ├── qa/
│   └── prod/
└── modules/
    ├── network/     # VPC, subnets, security groups
    ├── compute/     # EC2 + Elastic IP
    ├── database/    # RDS PostgreSQL
    ├── storage/     # S3 buckets (frontend + APK)
    └── ecr/         # ECR + IAM Role OIDC para GitHub Actions
```

## Estado remoto

El estado de Terraform se almacena en S3 con bloqueo en DynamoDB:

- **Bucket**: `dmc-final-terrastate-app`
- **Keys**: `thaqhiri/dev/`, `thaqhiri/qa/`, `thaqhiri/prod/`
- **DynamoDB**: `thaqhiri-terraform-locks`

## CI/CD

El pipeline `.github/workflows/terraform.yml` ejecuta:

- **PR a main** → `terraform plan` en dev (comentario automático en el PR)
- **Merge a main** → `terraform apply` en dev → qa → prod (con aprobación manual)
- **workflow_dispatch** → plan / apply / destroy manual por ambiente

## Ejecución local (primera vez / bootstrap)

```bash
export AWS_PROFILE=dmc_final
cd environments/dev
terraform init
terraform apply \
  -var="db_username=<usuario>" \
  -var="db_password=<password>" \
  -var="ssh_public_key=$(cat ~/.ssh/id_ed25519.pub)"
```

> El primer apply de cada ambiente debe hacerse en local porque el IAM Role OIDC aún no existe.

## Decisiones técnicas

- **OIDC sin credenciales estáticas**: GitHub Actions asume un IAM Role por ambiente mediante OIDC, eliminando el uso de `AWS_ACCESS_KEY_ID` / `AWS_SECRET_ACCESS_KEY`.
- **RDS compartido QA/Prod**: por restricción de cuota Free Tier (máx. 2 instancias RDS). El RDS de QA es accesible públicamente con acceso restringido por Security Group a la IP de prod.
- **Monitoreo solo en dev**: el stack Prometheus + Grafana + Loki + Jaeger se despliega únicamente en dev para mantener la complejidad acotada.
