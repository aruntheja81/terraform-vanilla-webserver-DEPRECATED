module "autoscaling" {
  source                = "./modules/autoscaling"
  namespace          = "${var.namespace}"
  aws_region            = "${var.aws_region}"
  aws_instance_ami      = "${var.aws_instance_ami}"
  aws_instance_type     = "${var.aws_instance_type}"
  subnet_ids            = "${module.network.private_subnet_ids}"
  vpc_security_group_id = "${module.network.vpc_security_group_id}"
  ssh_key_name          = "${var.ssh_key_name}"
  instance_profile_name = "${module.iam.instance_profile_name}"
  pg_user               = "${module.database.pg_user}"
  pg_password           = "${module.database.pg_password}"
  pg_database = "${module.database.pg_database}"
  pg_hostname           = "${module.database.pg_hostname}"
  pg_port               = "${module.database.pg_port}"
  vpc_id = "${module.network.vpc_id}"
  webapp_security_group_id = "${module.network.webapp_security_group_id}"
  public_subnet_ids = "${module.network.public_subnet_ids}"
  lb_security_group_id = "${module.network.lb_security_group_id}"
}

module "database" {
  source                = "./modules/database"
  namespace          = "${var.namespace}"
  aws_instance_type     = "${var.aws_instance_type}"
  vpc_security_group_id = "${module.network.db_vpc_security_group_id}"
  //vpc_security_group_id = "${module.network.vpc_security_group_id}"
  db_subnet_group_name  = "${module.network.db_subnet_group_id}"
}

module "iam" {
  source             = "./modules/iam"
  namespace       = "${var.namespace}"
}

module "network" {
  source       = "./modules/network"
  namespace = "${var.namespace}"
}

output "pg_password" {
  value = "${module.database.pg_password}"
}
/*
output "lb_dns_name" {
  value = "${module.autoscaling.lb_dns_name}"
}
*/

