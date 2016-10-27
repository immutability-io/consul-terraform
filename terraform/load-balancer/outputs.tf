
output "dns_name" {
    value = "${aws_elb.load-balancer.dns_name}"
}
