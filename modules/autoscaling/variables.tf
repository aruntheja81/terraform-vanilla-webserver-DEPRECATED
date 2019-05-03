variable "namespace" {
  type = string
}

variable "aws_instance_ami" {
  type = string
}

variable "aws_instance_type" {
  type = string
}

variable "ssh_key_name" {
  type = string
}

variable "instance_profile_name" {
  type = string
}

variable "sg" {
  type = any
}

variable "vpc" {
  type = any
}

variable "pg_config" {
  type = any
}


