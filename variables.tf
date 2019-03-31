variable "namespace" {
  description = "The project namespace to use for unique resource naming"
}

variable "aws_region" {
  description = "AWS region"
  default = "us-west-2"
}

variable "aws_instance_ami" {
  description = "Amazon Machine Image ID. An Amazon linux ami"
  default = "ami-7172b611"
}

variable "aws_instance_type" {
  description = "EC2 instance type"
  default = "t2.medium"
}

variable "ssh_key_name" {
  description = "AWS key pair name to install on the EC2 instance. Leave blank to not set."
  default = ""
}