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

module "database" {
  source = "../../modules/database"

  project                 = var.project
  environment             = var.environment
  instance_class          = var.rds_instance_class
  allocated_storage       = var.rds_allocated_storage
  db_name                 = var.db_name
  db_username             = var.db_username
  db_password             = var.db_password
  subnet_ids              = module.network.private_subnet_ids
  security_group_id       = module.network.sg_rds_id
  skip_final_snapshot     = true
  deletion_protection     = false
  backup_retention_period = 0
}

module "storage" {
  source = "../../modules/storage"

  project       = var.project
  environment   = var.environment
  bucket_suffix = var.bucket_suffix
}

module "monitoring" {
  source = "../../modules/monitoring"

  project                  = var.project
  environment              = var.environment
  instance_type            = var.monitoring_instance_type
  subnet_id                = module.network.public_subnet_ids[0]
  vpc_id                   = module.network.vpc_id
  vpc_cidr                 = var.vpc_cidr
  sg_app_id                = module.network.sg_ec2_id
  key_name                 = "${var.project}-${var.environment}-key"
  ssh_allowed_cidrs        = var.ssh_allowed_cidrs
  monitoring_allowed_cidrs = var.monitoring_allowed_cidrs
}

module "ecr" {
  source = "../../modules/ecr"

  project              = var.project
  environment          = var.environment
  github_org             = var.github_org
  github_repos           = var.github_repos
  create_oidc_provider   = true  # Solo true en dev; qa y prod lo referencian
  max_image_count        = 3
  tfstate_bucket         = "dmc-final-terrastate-app"
  tfstate_dynamodb_table = "thaqhiri-terraform-locks"
}
