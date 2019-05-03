output "public_subnet_ids" {
  value = "${module.vpc.public_subnets}"
}

output "private_subnet_ids" {
  value = "${module.vpc.private_subnets}"
}

output "vpc_security_group_id" {
  value = "${aws_security_group.main.id}"
}

output "db_vpc_security_group_id" {
  value = "${aws_security_group.db.id}"
}

output "webapp_security_group_id" {
  value = "${aws_security_group.webapp.id}"
}

output "lb_security_group_id" {
  value = "${aws_security_group.main.id}"
}
output "db_subnet_group_id" {
  value = "${module.vpc.database_subnet_group}"
}

output "vpc_id" {
  value = "${module.vpc.vpc_id}"
}