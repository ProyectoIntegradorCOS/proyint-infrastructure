locals {
  name_prefix = "${var.project}-${var.environment}"
}

# DB Subnet Group: RDS debe estar en al menos 2 AZs (aunque sea Single-AZ)
resource "aws_db_subnet_group" "main" {
  name       = "${local.name_prefix}-db-subnet-group"
  subnet_ids = var.subnet_ids

  tags = {
    Name        = "${local.name_prefix}-db-subnet-group"
    Project     = var.project
    Environment = var.environment
  }
}

# Parameter Group para PostgreSQL 15
resource "aws_db_parameter_group" "main" {
  name   = "${local.name_prefix}-pg15"
  family = "postgres15"

  parameter {
    name  = "log_connections"
    value = "1"
  }

  parameter {
    name  = "log_disconnections"
    value = "1"
  }

  tags = {
    Name        = "${local.name_prefix}-pg15"
    Project     = var.project
    Environment = var.environment
  }
}

# RDS PostgreSQL db.t3.micro (Free Tier: 750h/mes, 20GB)
resource "aws_db_instance" "main" {
  identifier        = "${local.name_prefix}-db"
  engine            = "postgres"
  engine_version    = "15"
  instance_class    = var.instance_class
  allocated_storage = var.allocated_storage
  storage_type      = "gp2"

  # storage_encrypted=false para evitar costos en Free Tier
  storage_encrypted = false

  db_name  = var.db_name
  username = var.db_username
  password = var.db_password

  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [var.security_group_id]
  parameter_group_name   = aws_db_parameter_group.main.name

  # Single-AZ (Free Tier — Multi-AZ tiene costo)
  multi_az            = false
  publicly_accessible = var.publicly_accessible

  skip_final_snapshot     = var.skip_final_snapshot
  deletion_protection     = var.deletion_protection
  backup_retention_period = var.backup_retention_period
  apply_immediately       = true

  tags = {
    Name        = "${local.name_prefix}-db"
    Project     = var.project
    Environment = var.environment
  }
}
