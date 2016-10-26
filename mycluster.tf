provider "aws" {
    region = "${var.region}"
}

module "vault-pki" {
    source = "./terraform/vault-pki"
    certificate = "${var.consul_certificate}"
    private_key = "${var.consul_key}"
    issuer_certificate = "${var.root_certificate}"
    common_name = "${var.common_name}"
    ip_sans = "${var.ip_sans}"
    vault_token = "${var.vault_token}"
    vault_addr = "${var.vault_addr}"
}

resource "aws_security_group" "consul" {
    name = "${var.tagName}-security-group"
    description = "Consul internal traffic + maintenance."
    vpc_id = "${var.vpc_id}"

    // These are for internal traffic
    ingress {
        from_port = 0
        to_port = 65535
        protocol = "tcp"
        self = true
    }

    ingress {
        from_port = 0
        to_port = 65535
        protocol = "udp"
        self = true
    }

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["${var.ingress_22}"]
    }

    ingress {
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = 9999
        to_port = 9999
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

module "consul-cluster" {
    source = "./terraform/consul-cluster"
    ami = "${var.ami}"
    servers = "${var.servers}"
    private_key = "${file(var.private_key)}"
    key_name = "${var.key_name}"
    security_group_id = "${aws_security_group.consul.id}"
    associate_public_ip_address = "${var.associate_public_ip_address}"
    subnet_id = "${var.subnet_id}"
    vpc_id = "${var.vpc_id}"
    ingress_22 = "${var.ingress_22}"
    tagFinance = "${var.tagFinance}"
    tagOwnerEmail = "${var.tagOwnerEmail}"
    tagSchedule = "${var.tagSchedule}"
    tagBusinessJustification = "${var.tagBusinessJustification}"
    tagAutoStart = "${var.tagAutoStart}"
    datacenter = "${var.datacenter}"
    gossip_encryption_key = "${var.gossip_encryption_key}"
    consul_certificate = "${var.consul_certificate}"
    consul_key = "${var.consul_key}"
    root_certificate = "${var.root_certificate}"
    password_file = "${var.password_file}"
}

module "consul-service" {
    source = "./terraform/consul-service"
    consul_cluster_ips = "${module.consul-cluster.private_server_ips}"
    security_group_id = "${aws_security_group.consul.id}"
    ami = "${var.ami}"
    service_count = "${var.service_count}"
    service_config = "${var.service_config}"
    private_key = "${file(var.private_key)}"
    key_name = "${var.key_name}"
    associate_public_ip_address = "${var.associate_public_ip_address}"
    subnet_id = "${var.subnet_id}"
    vpc_id = "${var.vpc_id}"
    ingress_22 = "${var.ingress_22}"
    tagFinance = "${var.tagFinance}"
    tagOwnerEmail = "${var.tagOwnerEmail}"
    tagSchedule = "${var.tagSchedule}"
    tagBusinessJustification = "${var.tagBusinessJustification}"
    tagAutoStart = "${var.tagAutoStart}"
    datacenter = "${var.datacenter}"
    gossip_encryption_key = "${var.gossip_encryption_key}"
    consul_certificate = "${var.consul_certificate}"
    consul_key = "${var.consul_key}"
    root_certificate = "${var.root_certificate}"
    rest_service_url = "${var.rest_service_url}"
}

module "fabio" {
    source = "./terraform/fabio"
    consul_cluster_ips = "${module.consul-cluster.private_server_ips}"
    security_group_id = "${aws_security_group.consul.id}"
    ami = "${var.ami}"
    service_count = "1"
    private_key = "${file(var.private_key)}"
    key_name = "${var.key_name}"
    associate_public_ip_address = "${var.associate_public_ip_address}"
    subnet_id = "${var.subnet_id}"
    vpc_id = "${var.vpc_id}"
    ingress_22 = "${var.ingress_22}"
    tagFinance = "${var.tagFinance}"
    tagOwnerEmail = "${var.tagOwnerEmail}"
    tagSchedule = "${var.tagSchedule}"
    tagBusinessJustification = "${var.tagBusinessJustification}"
    tagAutoStart = "${var.tagAutoStart}"
    datacenter = "${var.datacenter}"
    gossip_encryption_key = "${var.gossip_encryption_key}"
    consul_certificate = "${var.consul_certificate}"
    consul_key = "${var.consul_key}"
    root_certificate = "${var.root_certificate}"
    password_file = "${var.password_file}"
}

resource "aws_iam_server_certificate" "consul_certificate" {
    name_prefix      = "consul"
    certificate_body = "${file(var.consul_certificate)}"
    private_key      = "${file(var.consul_key)}"

    lifecycle {
        create_before_destroy = true
    }
}

resource "aws_elb" "consul-ui" {
    name                      = "consul-ui-elb"
    availability_zones        = ["us-east-1b"]
    cross_zone_load_balancing = true

    listener {
        instance_port      = 443
        instance_protocol  = "https"
        lb_port            = 443
        lb_protocol        = "https"
        ssl_certificate_id = "${aws_iam_server_certificate.consul_certificate.arn}"
    }

    health_check {
        healthy_threshold = 2
        unhealthy_threshold = 5
        timeout = 10
        target = "HTTPS:443/index.html"
        interval = 30
    }
    security_groups = ["${aws_security_group.consul.id}"]
    instances = ["${module.consul-cluster.instance_ids}"]

}


resource "aws_route53_record" "api" {
   zone_id = "${var.aws_route53_zone_id}"
   name = "api.${var.domain_name}"
   type = "A"
   ttl = "30"
   records = ["${module.fabio.public_server_ips}"]
}


resource "aws_route53_record" "consul" {
   zone_id = "${var.aws_route53_zone_id}"
   name = "consul.${var.domain_name}"
   type = "CNAME"
   ttl = "30"
   records = ["${aws_elb.consul-ui.dns_name}"]
}
