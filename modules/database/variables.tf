variable "namespace" {
    type = string
}

variable "aws_instance_type" {
  type = string
}

variable "vpc" {
    type = any
}

variable "sg" {
    type = any
}