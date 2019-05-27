module "autoscaling" {
  source                = "./modules/autoscaling"
  namespace             = var.namespace

  vpc                   = module.network.vpc
  sg                    = module.network.sg
  db_config             = module.database.db_config
}

module "database" {
  source            = "./modules/database"
  namespace         = var.namespace
  
  vpc               = module.network.vpc 
  sg                = module.network.sg
}

module "networking" {
  source    = "./modules/networking"
  namespace = var.namespace
}

output "db_password" {
  value = module.database.db_config.password
}

output "lb_dns_name" {
  value = module.autoscaling.lb_dns_name
}