erraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source     = "./modules/vpc"
  cidr_block = var.vpc_cidr
}

module "ec2" {
  source        = "./modules/ec2"
  subnet_id     = module.vpc.public_subnet_id
  instance_type = var.instance_type
}

module "rds" {
  source          = "./modules/rds"
  subnet_group_id = module.vpc.db_subnet_group_id
  db_name         = var.db_name
  username        = var.db_username
  password        = var.db_password
}

module "s3" {
  source      = "./modules/s3"
  bucket_name = var.bucket_name
}
