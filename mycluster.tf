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
    alt_names = "${var.alt_names}"
    vault_token = "${var.vault_token}"
    vault_addr = "${var.vault_addr}"
}

module "bastion" {
    source = "./terraform/bastion"
    ami = "ami-2d39803a"
    key_name = "${var.key_name}"
    subnet_id = "${var.subnet_id}"
    vpc_id = "${var.vpc_id}"
    vpc_cidr = "${var.vpc_cidr}"
    tagFinance = "${var.tagFinance}"
    tagOwnerEmail = "${var.tagOwnerEmail}"
    tagSchedule = "${var.tagSchedule}"
    tagBusinessJustification = "${var.tagBusinessJustification}"
    tagAutoStart = "${var.tagAutoStart}"
}

module "consul-cluster" {
    source = "./terraform/consul-cluster"
    ami = "${var.ami}"
    servers = "${var.servers}"
    private_key = "${file(var.private_key)}"
    key_name = "${var.key_name}"
    bastion_public_ip = "${module.bastion.public_ip}"
    bastion_user = "${module.bastion.user}"
    associate_public_ip_address = "${var.associate_public_ip_address}"
    subnet_id = "${var.subnet_id}"
    vpc_id = "${var.vpc_id}"
    vpc_cidr = "${var.vpc_cidr}"
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
    instance_type = "t2.nano"
    consul_cluster_ips = "${module.consul-cluster.private_server_ips}"
    ami = "${var.ami}"
    service_count = "${var.service_count}"
    service_config = "${var.service_config}"
    private_key = "${file(var.private_key)}"
    key_name = "${var.key_name}"
    bastion_public_ip = "${module.bastion.public_ip}"
    bastion_user = "${module.bastion.user}"
    associate_public_ip_address = "${var.associate_public_ip_address}"
    subnet_id = "${var.subnet_id}"
    vpc_id = "${var.vpc_id}"
    vpc_cidr = "${var.vpc_cidr}"
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
    ami = "${var.ami}"
    service_count = "2"
    private_key = "${file(var.private_key)}"
    key_name = "${var.key_name}"
    bastion_public_ip = "${module.bastion.public_ip}"
    bastion_user = "${module.bastion.user}"
    associate_public_ip_address = "${var.associate_public_ip_address}"
    subnet_id = "${var.subnet_id}"
    vpc_id = "${var.vpc_id}"
    vpc_cidr = "${var.vpc_cidr}"
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

module "consul-ui-load-balancer" {
    source = "./terraform/load-balancer"
    tagName = "consul-ui"
    tagFinance = "${var.tagFinance}"
    tagOwnerEmail = "${var.tagOwnerEmail}"
    tagSchedule = "${var.tagSchedule}"
    tagBusinessJustification = "${var.tagBusinessJustification}"
    tagAutoStart = "${var.tagAutoStart}"
    vpc_id = "${var.vpc_id}"
    vpc_cidr = "${var.vpc_cidr}"
    ssl_certificate_id = "${aws_iam_server_certificate.consul_certificate.arn}"
    instance_ids = ["${module.consul-cluster.instance_ids}"]
}


resource "aws_route53_record" "fabio_a" {
    zone_id = "${var.aws_route53_zone_id}"
    name = "fabio.${var.domain_name}"
    type = "A"
    ttl = "10"
    weighted_routing_policy {
      weight = 50
    }
    set_identifier = "fabio_a"
    records = ["${element(module.fabio.public_server_ips, 0)}"]
}

resource "aws_route53_record" "fabio_b" {
    zone_id = "${var.aws_route53_zone_id}"
    name = "fabio.${var.domain_name}"
    type = "A"
    ttl = "10"
    weighted_routing_policy {
      weight = 50
    }
    set_identifier = "fabio_b"
    records = ["${element(module.fabio.public_server_ips, 1)}"]
}

resource "aws_route53_record" "consul" {
   zone_id = "${var.aws_route53_zone_id}"
   name = "consul.${var.domain_name}"
   type = "CNAME"
   ttl = "10"
   records = ["${module.consul-ui-load-balancer.dns_name}"]
}
/*
resource "aws_route53_record" "resty" {
    zone_id = "${var.aws_route53_zone_id}"
    name = "resty.${var.domain_name}"
    type = "A"
    ttl = "10"
    records = ["${module.consul-service.public_server_ips}"]
}


resource "aws_route53_health_check" "resty-health" {
    count = "${var.service_count}"
    ip_address = "${element(module.consul-service.public_server_ips, count.index)}"
    port = 8080
    type = "HTTP"
    resource_path = "/unhealthy"
    failure_threshold = "3"
    request_interval = "30"

}
*/
