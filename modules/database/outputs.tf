output "pg_config" {
  value = {
    user     = "${aws_db_instance.database.username}"
    password = "${local.pg_password}"
    database = "${aws_db_instance.database.name}"
    hostname = "${aws_db_instance.database.address}"
    port     = "${aws_db_instance.database.port}"
  }
}