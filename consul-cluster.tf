provider "aws" {
    region = "${var.region}"
}

module "consul" {
    source = "github.com/Immutability-io/consul-terraform//terraform"
    ami = "${var.ami}"
    private_key = "${file(var.private_key)}"
    key_name = "${var.key_name}"
    associate_public_ip_address = "${var.associate_public_ip_address}"
    subnet_id = "${var.subnet_id}"
    vpc_id = "${var.vpc_id}"
    tagFinance = "${var.tagFinance}"
    tagOwnerEmail = "${var.tagOwnerEmail}"
}

resource "null_resource" "consul_cluster" {
    count = "${var.servers}"

    provisioner "remote-exec" {
      # Bootstrap script called with private_ip of each node in the clutser
        connection {
            host = "${element(module.consul.public_server_ips, count.index)}"
        }
        inline = [
            "echo ${join(",", module.consul.private_server_ips)} > /tmp/consul-server-cluster"
        ]
    }
}

output "public_server_ips" {
    value = "${module.consul.public_server_ips}"
}

output "private_server_ips" {
    value = "${module.consul.private_server_ips}"
}
