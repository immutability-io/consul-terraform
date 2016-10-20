provider "aws" {
    region = "${var.region}"
}

module "consul-cluster" {
    source = "github.com/Immutability-io/consul-terraform//terraform/consul-cluster"
    ami = "${var.ami}"
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
}
