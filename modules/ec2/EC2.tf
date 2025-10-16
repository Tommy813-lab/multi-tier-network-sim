resource "aws_instance" "this" {
  ami                    = var.ami
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  key_name               = var.key_name      # optional SSH key
  associate_public_ip_address = var.public_ip # optional, for public subnet

  vpc_security_group_ids = var.security_group_ids  # optional security groups

  tags = merge(
    {
      Name        = var.instance_name
      Environment = var.environment
    },
    var.extra_tags # optional extra tags
  )
}
