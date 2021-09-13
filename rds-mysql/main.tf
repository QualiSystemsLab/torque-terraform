provider "aws" {
  region = "eu-west-1"
}

resource "aws_vpc" "sb_services" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "sb_services" {
  vpc_id     = aws_vpc.sb_services.id
  cidr_block = "10.0.0.0/16"

}

resource "aws_db_subnet_group" "rds" {
  name = "rds-${var.sandbox_id}-subnet-group"
  subnet_ids = [aws_subnet.sb_services.id]

  tags = {
    Name = "RDS-subnet-group"
  }
}


resource "aws_db_instance" "default" {
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.medium"
  identifier           = "rds-${var.sandbox_id}"
  name                 = "${var.db_name}"
  username             = "${var.username}"
  password             = "${var.password}"
  parameter_group_name = "default.mysql5.7"
  db_subnet_group_name = "${aws_db_subnet_group.rds.id}"
  vpc_security_group_ids    = ["${aws_security_group.rds.id}"]
  skip_final_snapshot       = true
  final_snapshot_identifier = "Ignore"
}
