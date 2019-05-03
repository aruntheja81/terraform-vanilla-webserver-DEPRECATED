variable "namespace" {
  type = "string"
}

variable "aws_instance_ami" {
  type = "string"
}

variable "aws_instance_type" {
  type = "string"
}

variable "ssh_key_name" {
  type = "string"
}

variable "subnet_ids" {
  type = "list"
}

variable "public_subnet_ids" {
  type = "list"
}
variable "webapp_security_group_id" {
  type = "string"
}
variable "vpc_security_group_id" {
  type = "string"
}

variable "instance_profile_name" {
  type = "string"
}

variable "pg_user" {
  type = "string"
}
variable "pg_password" {
  type = "string"
}

variable "pg_database" {
  type = "string"
}

variable "pg_hostname" {
  type = "string"
}
variable "pg_port" {
  type = "string"
}

variable "aws_region" {
  type = "string"
}

variable "vpc_id" {
  type = "string"
}
variable "lb_security_group_id" {
  type = "string"
}