resource "random_id" "random_16" {
  byte_length = "${16*3/4}"
}

locals {
  pg_password = "${random_id.random_16.b64_url}"
}

resource "aws_db_instance" "database" {
  allocated_storage         = 10
  engine                    = "mysql"
  engine_version            = "5.7"
  instance_class            = "db.${var.aws_instance_type}"
  identifier                = "${var.namespace}-db-instance"
  name                      = "dancevita"
  username                  = "aira"
  password                  = "${local.pg_password}"
  db_subnet_group_name      = "${var.db_subnet_group_name}"
  vpc_security_group_ids    = ["${var.vpc_security_group_id}"]
  skip_final_snapshot = true
}