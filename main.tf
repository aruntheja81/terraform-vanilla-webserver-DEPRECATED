module "autoscaling" {
  source                = "./modules/autoscaling"
  namespace             = var.namespace
  aws_instance_ami      = var.aws_instance_ami
  aws_instance_type     = var.aws_instance_type
  ssh_key_name          = var.ssh_key_name

  vpc                   = module.network.vpc
  sg                    = module.network.sg
  instance_profile_name = module.iam.instance_profile_name
  pg_config             = module.database.pg_config
}

module "database" {
  source            = "./modules/database"
  namespace         = var.namespace
  aws_instance_type = var.aws_instance_type
  
  vpc               = module.network.vpc 
  sg                = module.network.sg
}

module "iam" {
  source    = "./modules/iam"
  namespace = var.namespace
}

module "network" {
  source    = "./modules/network"
  namespace = var.namespace
}

output "pg_password" {
  value = module.database.pg_config.password
}

output "lb_dns_name" {
  value = module.autoscaling.lb_dns_name
}