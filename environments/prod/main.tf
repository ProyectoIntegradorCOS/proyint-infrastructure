module "network" {
  source = "../../modules/network"

  project              = var.project
  environment          = var.environment
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  availability_zones   = var.availability_zones
  ssh_allowed_cidrs    = var.ssh_allowed_cidrs
}

module "compute" {
  source = "../../modules/compute"

  project           = var.project
  environment       = var.environment
  instance_type     = var.ec2_instance_type
  subnet_id         = module.network.public_subnet_ids[0]
  security_group_id = module.network.sg_ec2_id
  ssh_public_key    = var.ssh_public_key
}

# RDS no se crea en prod por restricción de cuota Free Tier (máx. 2 instancias).
# El backend de prod apunta al RDS de QA: thaqhiri-qa-db.c5yeysa8c27n.us-west-2.rds.amazonaws.com

module "storage" {
  source = "../../modules/storage"

  project       = var.project
  environment   = var.environment
  bucket_suffix = var.bucket_suffix
}

module "ecr" {
  source = "../../modules/ecr"

  project              = var.project
  environment          = var.environment
  github_org             = var.github_org
  github_repos           = var.github_repos
  create_oidc_provider   = false  # El OIDC provider ya fue creado en dev
  max_image_count        = 10
  tfstate_bucket         = "dmc-final-terrastate-app"
  tfstate_dynamodb_table = "thaqhiri-terraform-locks"
}
