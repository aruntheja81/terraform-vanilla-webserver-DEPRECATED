output "lb_dns_name" {
    value = "${aws_elb.webapp.dns_name}"
}