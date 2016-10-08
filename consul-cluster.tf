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

data "template_file" "template-consul-config" {
    template = "${file(var.consul_template)}"
    vars {
        retry_join = "${join("\",\"", module.consul.private_server_ips)}"
        datacenter = "${var.datacenter}"
        gossip_encryption_key = "${var.gossip_encryption_key}"
    }
}
resource "null_resource" "secrets" {
  provisioner "local-exec" {
      scripts = [
          "sh ./scripts/secrets.sh ${var.common_name} ${var.certificate_path}"
      ]
  }
}


resource "null_resource" "consul_cluster" {
    count = "${var.servers}"
    connection {
        host = "${element(module.consul.public_server_ips, count.index)}"
        user = "ubuntu"
        private_key = "${file(var.private_key)}"
    }

    provisioner "file" {
        content = "${data.template_file.template-consul-config.rendered}"
        destination = "/tmp/consul.json"
    }

    provisioner "file" {
        source = "${var.root_certificate}"
        destination = "/tmp/root.crt"
    }

    provisioner "file" {
        source = "${var.consul_certificate}"
        destination = "/tmp/consul.crt"
    }

    provisioner "file" {
        source = "${var.consul_key}"
        destination = "/tmp/consul.key"
    }

    provisioner "remote-exec" {
        scripts = [
            "./scripts/setup.sh",
            "./scripts/service.sh"
        ]
    }

}

output "public_server_ips" {
    value = "${module.consul.public_server_ips}"
}

output "private_server_ips" {
    value = "${module.consul.private_server_ips}"
}
