output "vpc_id" {
  value = aws_vpc.this.id
}

output "public_subnet_id" {
  value = aws_subnet.public.id
}

output "db_subnet_group_id" {
  value = aws_db_subnet_group.this.id
}
