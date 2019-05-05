resource "aws_iam_role" "webserver" {
  name = "${var.namespace}-iam_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_instance_profile" "webserver" {
  name = "${var.namespace}-iam_instance_profile"
  role = "${aws_iam_role.webserver.name}"
}

data "aws_iam_policy_document" "webserver" {
  statement {
      effect = "Allow"
      actions = [
        "s3:*",
        "logs:*",
        "rds:*",
        "ec2:*"
      ]
      resources = [
          "*"
      ] 
  }
}

resource "aws_iam_role_policy" "webserver" {
  name   = "${var.namespace}-iam_role_policy"
  role   = "${aws_iam_role.webserver.name}"
  policy = "${data.aws_iam_policy_document.webserver.json}"
}

data "template_cloudinit_config" "config" {
  gzip          = true
  base64_encode = true

  part {
    content_type = "text/cloud-config"
    content      = templatefile("${path.module}/cloud_config.yaml",var.pg_config)
  }
}

resource "aws_launch_template" "webserver" {
  name_prefix            = var.namespace
  image_id               = var.aws_instance_ami
  instance_type          = var.aws_instance_type
  key_name               = var.ssh_key_name
  user_data              = data.template_cloudinit_config.config.rendered
  iam_instance_profile {
    name = aws_iam_instance_profile.webserver.name
  }
  vpc_security_group_ids = [var.sg.websvr]
}

resource "aws_autoscaling_group" "webserver" {
  name = "${var.namespace}-asg"
  min_size            = 1
  max_size            = 3
  vpc_zone_identifier = var.vpc.private_subnets[0]
  target_group_arns   = module.alb.target_group_arns

  launch_template {
    id = aws_launch_template.webserver.id
  }
}

module "alb" {
  //source = "terraform-aws-modules/alb/aws"
  source = "./terraform-aws-alb"
  load_balancer_name = "${var.namespace}-alb"
  security_groups    = [var.sg.lb]
  subnets = var.vpc.public_subnets[0]
  vpc_id                   = var.vpc.vpc_id
  logging_enabled          = false
  http_tcp_listeners       = [{port=80,protocol="HTTP"}]
  http_tcp_listeners_count = "1"
  target_groups            = [{name="websvr",backend_protocol="HTTP",backend_port=8080}]
  target_groups_count      = "1"
}