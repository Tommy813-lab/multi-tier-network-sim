# VPC
resource "aws_vpc" "this" {
  cidr_block           = var.cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name        = var.vpc_name
    Environment = var.environment
  }
}

# Public Subnets (Multi-AZ)
resource "aws_subnet" "public" {
  for_each = toset(var.availability_zones)

  vpc_id            = aws_vpc.this.id
  cidr_block        = cidrsubnet(var.cidr_block, 8, index(var.availability_zones, each.key))
  availability_zone = each.key
  map_public_ip_on_launch = true

  tags = {
    Name        = "${var.vpc_name}-public-${each.key}"
    Environment = var.environment
  }
}

# DB Subnet Group (supports multiple subnets for HA)
resource "aws_db_subnet_group" "this" {
  name       = "${var.vpc_name}-db-subnet-group"
  subnet_ids = [for s in aws_subnet.public : s.id]  # all public subnets, can switch to private if desired

  tags = {
    Name        = "${var.vpc_name}-db-subnet-group"
    Environment = var.environment
  }
}
