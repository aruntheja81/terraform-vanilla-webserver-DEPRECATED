output "pg_user" {
  value = "${aws_db_instance.database.username}"
}
output "pg_password" {
  value = "${local.pg_password}"
}

output "pg_database" {
  value = "${aws_db_instance.database.name}"
}

output "pg_hostname" {
  value = "${aws_db_instance.database.address}"
}
output "pg_port" {
  value = "${aws_db_instance.database.port}"
}