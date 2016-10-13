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
    ingress_22 = "${var.ingress_22}"
    tagFinance = "${var.tagFinance}"
    tagOwnerEmail = "${var.tagOwnerEmail}"
}

data "template_file" "template-client-consul-config" {
    template = "${file(var.client_consul_template)}"
    vars {
        retry_join = "${join("\",\"", module.consul.private_server_ips)}"
        datacenter = "${var.datacenter}"
        gossip_encryption_key = "${var.gossip_encryption_key}"
    }
}

resource "aws_instance" "microservice"
{
    ami = "${var.ami}"
    instance_type = "${var.instance_type}"
    key_name = "${var.key_name}"
    subnet_id = "${var.subnet_id}"
    associate_public_ip_address = "${var.associate_public_ip_address}"
    vpc_security_group_ids = ["${module.consul.security_group_id}"]

    connection
    {
        user = "ubuntu"
        private_key = "${var.private_key}"
    }

    tags
    {
      Name = "microservice"
      Finance = "${var.tagFinance}"
      OwnerEmail = "${var.tagOwnerEmail}"
    }

    provisioner "file" {
        content = "${data.template_file.template-client-consul-config.rendered}"
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

    provisioner "file"
    {
        source = "./scripts/upstart.conf"
        destination = "/tmp/upstart.conf"
    }

    provisioner "remote-exec" {
        scripts = [
            "./scripts/setup_certs.sh",
            "./scripts/install.sh",
            "./scripts/service.sh"
        ]
    }
}


data "template_file" "template-consul-config" {
    template = "${file(var.consul_template)}"
    vars {
        retry_join = "${join("\",\"", module.consul.private_server_ips)}"
        datacenter = "${var.datacenter}"
        gossip_encryption_key = "${var.gossip_encryption_key}"
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

    provisioner "file" {
        source = "${var.password_file}"
        destination = "/tmp/.htpasswd"
    }

    provisioner "remote-exec" {
        scripts = [
            "./scripts/setup.sh",
            "./scripts/setup_certs.sh",
            "./scripts/service.sh",
            "./scripts/nginx.sh"
        ]
    }
}

output "public_server_ips" {
    value = "${module.consul.public_server_ips}"
}

output "private_server_ips" {
    value = "${module.consul.private_server_ips}"
}
