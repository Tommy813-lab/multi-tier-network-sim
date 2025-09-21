resource "aws_instance" "this" {
  ami           = "ami-0c55b159cbfafe1f0" # Amazon Linux 2 (us-east-1)
  instance_type = var.instance_type
  subnet_id     = var.subnet_id

  tags = {
    Name = "multi-tier-ec2"
  }
}
