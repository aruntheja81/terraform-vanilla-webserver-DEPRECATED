data "template_file" "cloud_config" {
  template = "${file("${path.module}/cloud_config.yaml")}"

  vars {
    PG_USER     = "${var.pg_user}"
    PG_PASSWORD = "${var.pg_password}"
    PG_DATABASE = "${var.pg_database}"
    PG_HOSTNAME = "${var.pg_hostname}"
    PG_PORT     = "${var.pg_port}"
  }
}

data "template_cloudinit_config" "config" {
  gzip          = true
  base64_encode = true

  part {
    content_type = "text/cloud-config"
    content      = "${data.template_file.cloud_config.rendered}"
  }
}

resource "aws_launch_template" "webapp" {
  name_prefix            = "${var.namespace}"
  image_id               = "${var.aws_instance_ami}"
  instance_type          = "${var.aws_instance_type}"
  key_name               = "${var.ssh_key_name}"
  user_data              = "${data.template_cloudinit_config.config.rendered}"
  iam_instance_profile {
    name = "${var.instance_profile_name}"
  }
  vpc_security_group_ids = ["${var.webapp_security_group_id}"]
}

/*resource "aws_launch_configuration" "webapp" {
  name_prefix   = "${var.namespace}"
  image_id      = "${var.aws_instance_ami}"
  instance_type = "${var.aws_instance_type}"
  key_name      = "${var.ssh_key_name}"
  user_data     = "${data.template_cloudinit_config.config.rendered}"

  iam_instance_profile {
    name = "${var.instance_profile_name}"
  }

  security_groups = ["${var.webapp_security_group_id}"]

  /*block_device_mappings {
    device_name = "/dev/sda1"

    ebs {
      volume_size = 20
    }
  }
}*/

resource "aws_autoscaling_group" "webapp" {
  // name                      = "${var.namespace} - ${aws_launch_configuration.webapp.name}"
  name = "my asg"

  //availability_zones        = ["${var.aws_region}a", "${var.aws_region}b", "${var.aws_region}c"]
  min_size            = 1
  max_size            = 3
  vpc_zone_identifier = ["${var.subnet_ids}"]
  target_group_arns   = ["${module.alb.target_group_arns}"]

  launch_template {
    id = "${aws_launch_template.webapp.id}"
  }

  //launch_configuration      = "${aws_launch_configuration.webapp.name}"
}

module "alb" {
  source             = "terraform-aws-modules/alb/aws"
  load_balancer_name = "my-alb"
  security_groups    = ["${var.lb_security_group_id}"]

  //log_bucket_name               = "logs-us-east-2-123456789012"
  //log_location_prefix           = "my-alb-logs"
  subnets = ["${var.public_subnet_ids}"]

  //tags                          = "${map("Environment", "test")}"
  vpc_id                   = "${var.vpc_id}"
  logging_enabled          = false
  http_tcp_listeners       = "${list(map("port", "80", "protocol", "HTTP"))}"
  http_tcp_listeners_count = "1"
  target_groups            = "${list(map("name", "webapp", "backend_protocol", "HTTP", "backend_port", "8080"))}"
  target_groups_count      = "1"
}
