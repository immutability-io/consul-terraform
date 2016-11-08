
resource "aws_elb" "load-balancer" {
    name                      = "${var.tagName}-elb"
    cross_zone_load_balancing = true

    listener {
        instance_port      = 443
        instance_protocol  = "https"
        lb_port            = 443
        lb_protocol        = "https"
        ssl_certificate_id = "${var.ssl_certificate_id}"
    }

    health_check {
        healthy_threshold = 2
        unhealthy_threshold = 5
        timeout = 10
        target = "HTTPS:443/index.html"
        interval = 30
    }

    security_groups = ["${aws_security_group.load-balancer.id}"]
    subnets = ["${var.subnet_ids}"]
    instances = ["${var.instance_ids}"]

    tags {
        Name = "${var.tagName}-elb"
        Finance = "${var.tagFinance}"
        OwnerEmail = "${var.tagOwnerEmail}"
        Schedule = "${var.tagSchedule}"
        BusinessJustification = "${var.tagBusinessJustification}"
        AutoStart = "${var.tagAutoStart}"
    }
}

resource "aws_security_group" "load-balancer" {
    name = "${var.tagName}-security-group"
    description = "load-balancer traffic"
    vpc_id = "${var.vpc_id}"

    // These are for internal traffic

    ingress {
        protocol    = -1
        from_port   = 0
        to_port     = 0
        cidr_blocks = ["${var.vpc_cidr}"]
    }

    ingress {
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}
