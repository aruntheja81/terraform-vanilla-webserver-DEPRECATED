module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "${var.namespace}-vpc"

  cidr = "10.0.0.0/16"

  azs             = ["us-west-2a", "us-west-2b", "us-west-2c"]
  private_subnets  = ["10.0.1.0/24","10.0.2.0/24","10.0.3.0/24"]
  public_subnets   = ["10.0.101.0/24", "10.0.102.0/24","10.0.103.0/24"]
  database_subnets = ["10.0.21.0/24", "10.0.22.0/24", "10.0.23.0/24"]
  assign_generated_ipv6_cidr_block = true
  create_database_subnet_group           = true
  enable_nat_gateway = true
  single_nat_gateway = true
}


resource "aws_security_group" "main" {
  name        = "${var.namespace}-lb-sg"
  description = "${var.namespace} security group"
  vpc_id      = "${module.vpc.vpc_id}"

  ingress {
    protocol  = -1
    from_port = 0
    to_port   = 0
    self      = true
  }

  ingress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = -1
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "webapp" {
  name        = "${var.namespace}-webapp-sg"
  description = "${var.namespace} security group"
  vpc_id      = "${module.vpc.vpc_id}"

  ingress {
    protocol  = -1
    from_port = 0
    to_port   = 0
    self      = true
  }

  ingress {
    protocol    = "tcp"
    from_port   = 8080
    to_port     = 8080
    security_groups = ["${aws_security_group.main.id}"]
  }

  egress {
    protocol    = -1
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "db" {
  name        = "${var.namespace}-db-sg"
  description = "${var.namespace} security group"
  vpc_id      = "${module.vpc.vpc_id}"

  ingress {
    protocol  = -1
    from_port = 0
    to_port   = 0
    self      = true
  }

  ingress {
    protocol  = -1
    from_port = 0
    to_port   = 0
    security_groups = ["${aws_security_group.webapp.id}"]
  }

 ingress {
    protocol  = -1
    from_port = 0
    to_port   = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = -1
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}