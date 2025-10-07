resource "aws_db_instance" "this" {
  allocated_storage    = 20
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t3.micro"
  name                 = var.db_name
  username             = var.username
  password             = var.password
  db_subnet_group_name = var.subnet_group_id
  skip_final_snapshot  = true
}
