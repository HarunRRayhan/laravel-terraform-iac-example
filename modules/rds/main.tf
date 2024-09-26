resource "aws_db_subnet_group" "default" {
  name       = "${var.application_name}-db-subnet-group"
  subnet_ids = var.private_subnet_ids

  tags = {
    Name = "${var.application_name} DB subnet group"
  }
}

resource "aws_security_group" "db" {
  name        = "${var.application_name}-db-sg"
  description = "Security group for ${var.application_name} database"
  vpc_id      = var.vpc_id

  ingress {
    description     = "MySQL from web server"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.web.id]
  }

  tags = {
    Name = "${var.application_name}-db-sg"
  }
}

resource "aws_db_instance" "default" {
  identifier           = "${var.application_name}-db"
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = var.db_instance_class
  db_name              = var.db_name
  username             = var.db_username
  password             = var.db_password
  parameter_group_name = "default.mysql8.0"
  skip_final_snapshot  = true

  vpc_security_group_ids = [aws_security_group.db.id]
  db_subnet_group_name   = aws_db_subnet_group.default.name

  tags = {
    Name = "${var.application_name}-db"
  }
}