module "autoscaling" {
  source                = "./modules/autoscaling"
  namespace             = var.namespace

  vpc                   = module.network.vpc
  sg                    = module.network.sg
  pg_config             = module.database.pg_config
}

module "database" {
  source            = "./modules/database"
  namespace         = var.namespace
  
  vpc               = module.network.vpc 
  sg                = module.network.sg
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