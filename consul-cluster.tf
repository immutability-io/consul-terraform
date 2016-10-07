provider "aws" {
    region = "${var.region}"
}

module "consul" {
    source = "github.com/Immutability-io/consul-terraform//terraform"
    key_path = "${var.key_path}"
    key_name = "${var.key_name}"
    associate_public_ip_address = "${var.associate_public_ip_address}"
    subnet_id = "${var.subnet_id}"
    vpc_id = "${var.vpc_id}"
    tagFinance = "${var.tagFinance}"
    tagOwnerEmail = "${var.tagOwnerEmail}"
}
