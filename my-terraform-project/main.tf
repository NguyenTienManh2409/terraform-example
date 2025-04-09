provider "aws" {
  region = "us-east-1"
}

module "network" {
  source            = "./modules/network"
  project           = var.project
  vpc_cidr          = "10.0.0.0/16"
  public_subnets    = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets   = ["10.0.3.0/24", "10.0.4.0/24"]
  availability_zones = ["us-east-1a", "us-east-1b"]
}

# Module EC2 (LEMP Server)
module "ec2" {
  source          = "./modules/ec2"
  project         = var.project
  vpc_id          = module.network.vpc_id
  public_subnet_id = module.network.public_subnet_ids[0]
  instance_type   = "t2.micro"
  key_name        = var.key_name
}

# Module RDS (MySQL Database)

module "rds" {
  source             = "./modules/rds"
  project            = var.project
  vpc_id             = module.network.vpc_id
  private_subnet_ids = module.network.private_subnet_ids
  instance_class     = "db.t3.micro"
  db_username        = "admin"
  db_password        = "SuperSecretPassword123"
  allowed_cidrs      = ["10.0.0.0/16"] 
}

module "backend" {
  source              = "./modules/backend"
  s3_bucket_name      = "terraform-bucket2409"
  dynamodb_table_name = "terraform-state"
  vpc_id              = module.network.vpc_id
  route_table_ids     = module.network.route_table_ids
  aws_region          = "us-east-1"
}

terraform {
  backend "s3" {
    bucket         = "terraform-bucket2409"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-state"
    encrypt = true
  }
}