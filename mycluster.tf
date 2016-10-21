provider "aws" {
    region = "${var.region}"
}

module "vault-pki" {
    source = "github.com/Immutability-io/consul-terraform//terraform/vault-pki"
    certificate = "${var.consul_certificate}"
    private_key = "${var.consul_key}"
    issuer_certificate = "${var.root_certificate}"
    common_name = "${var.common_name}"
    ip_sans = "${var.ip_sans}"
    vault_token = "${var.vault_token}"
    vault_addr = "${var.vault_addr}"
}

module "consul-cluster" {
    source = "github.com/Immutability-io/consul-terraform//terraform/consul-cluster"
    ami = "${var.ami}"
    servers = "${var.servers}"
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

module "consul-service" {
    source = "github.com/Immutability-io/consul-terraform//terraform/consul-service"
    consul_cluster_ips = "${module.consul-cluster.private_server_ips}"
    security_group_id = "${module.consul-cluster.security_group_id}"
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
    root_certificate = "${var.root_certificate}"
    rest_service_url = "${var.rest_service_url}"
}
