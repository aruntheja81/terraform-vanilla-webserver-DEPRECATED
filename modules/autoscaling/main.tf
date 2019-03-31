data "template_file" "cloud_config" {
  template = "${file("${path.module}/cloud_config.yaml")}"

  vars {
    PG_USER        = "${var.pg_user}"
    PG_PASSWORD    = "${var.pg_password}"
    PG_DATABASE = "${var.pg_database}"
    PG_HOSTNAME    = "${var.pg_hostname}"
    PG_PORT        = "${var.pg_port}"
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

resource "aws_launch_configuration" "webapp" {
  name_prefix          = "${var.namespace}"
  image_id             = "${var.aws_instance_ami}"
  instance_type        = "${var.aws_instance_type}"
  key_name             = "${var.ssh_key_name}"
  user_data            = "${data.template_cloudinit_config.config.rendered}"
  iam_instance_profile = "${var.instance_profile_name}"
  security_groups      = ["${var.vpc_security_group_id}"]

  root_block_device {
    volume_size = 8
  }
}

resource "aws_autoscaling_group" "webapp" {
  name                      = "${var.namespace} - ${aws_launch_configuration.webapp.name}"
  availability_zones        = ["${var.aws_region}a", "${var.aws_region}b", "${var.aws_region}c"]
  min_size                  = 1
  max_size                  = 3
  vpc_zone_identifier       = ["${var.subnet_ids}"]
  load_balancers            = ["${aws_elb.webapp.id}"]
  launch_configuration      = "${aws_launch_configuration.webapp.name}"
}

resource "aws_elb" "webapp" {
  internal = false
  subnets         = ["${var.subnet_ids}"]            //public
  security_groups = ["${var.vpc_security_group_id}"]

  listener {
    instance_port     = 8080
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "TCP:8080"
    interval            = 5
  }
}