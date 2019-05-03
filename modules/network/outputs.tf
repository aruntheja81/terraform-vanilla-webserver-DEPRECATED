output "vpc" {
  value = module.vpc
}

output "sg" {
  value = {
      lb=aws_security_group.loadbalancer.id
      db=aws_security_group.database.id
      websvr = aws_security_group.webserver.id
    }
}
output "lb" {
  value = aws_security_group.loadbalancer
}