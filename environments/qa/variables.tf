variable "aws_region"            { type = string; default = "us-east-1" }
variable "project"               { type = string; default = "thaqhiri" }
variable "environment"           { type = string; default = "staging" }
variable "vpc_cidr"              { type = string; default = "10.1.0.0/16" }
variable "public_subnet_cidrs"   { type = list(string); default = ["10.1.1.0/24", "10.1.2.0/24"] }
variable "private_subnet_cidrs"  { type = list(string); default = ["10.1.10.0/24", "10.1.20.0/24"] }
variable "availability_zones"    { type = list(string); default = ["us-east-1a", "us-east-1b"] }
variable "ssh_allowed_cidrs"     { type = list(string); default = ["0.0.0.0/0"] }
variable "ec2_instance_type"     { type = string; default = "t3.micro" }
variable "rds_instance_class"    { type = string; default = "db.t3.micro" }
variable "rds_allocated_storage" { type = number; default = 20 }
variable "db_name"               { type = string; default = "thaqhiri" }
variable "db_username"           { type = string; sensitive = true }
variable "db_password"           { type = string; sensitive = true }
variable "ssh_public_key"        { type = string; sensitive = true }
variable "bucket_suffix"         { type = string }
