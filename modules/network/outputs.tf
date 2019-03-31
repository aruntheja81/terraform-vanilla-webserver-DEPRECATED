output "subnet_ids" {
  value = "${aws_subnet.main.*.id}"
}

output "vpc_security_group_id" {
  value = "${aws_security_group.main.id}"
}

output "db_subnet_group_id" {
  value = "${aws_db_subnet_group.main.id}"
}