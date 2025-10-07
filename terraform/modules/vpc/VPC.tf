resource "aws_vpc" "this" {
  cidr_block           = var.cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true
}

resource "aws_subnet" "public" {
  vpc_id            = aws_vpc.this.id
  cidr_block        = cidrsubnet(var.cidr_block, 8, 0)
  availability_zone = "us-east-1a"
}

resource "aws_db_subnet_group" "this" {
  name       = "db-subnet-group"
  subnet_ids = [aws_subnet.public.id]
}
