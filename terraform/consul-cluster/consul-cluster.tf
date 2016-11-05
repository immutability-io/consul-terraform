
module "consul" {
    source = "../consul-node"
    ami = "${var.ami}"
    bastion_public_ip = "${var.bastion_public_ip}"
    bastion_user = "${var.bastion_user}"
    servers = "${var.servers}"
    private_key = "${var.private_key}"
    key_name = "${var.key_name}"
    associate_public_ip_address = "${var.associate_public_ip_address}"
    subnet_id = "${var.subnet_id}"
    vpc_id = "${var.vpc_id}"
    vpc_cidr = "${var.vpc_cidr}"
    tagName = "${var.tagName}"
    tagFinance = "${var.tagFinance}"
    tagOwnerEmail = "${var.tagOwnerEmail}"
    tagSchedule = "${var.tagSchedule}"
    tagBusinessJustification = "${var.tagBusinessJustification}"
    tagAutoStart = "${var.tagAutoStart}"
}

data "template_file" "template-consul-config" {
    template = "${file("${path.module}/config/consul_config.tpl")}"
    vars {
        retry_join = "${join("\",\"", module.consul.private_server_ips)}"
        datacenter = "${var.datacenter}"
        node_count = "${var.servers}"
        gossip_encryption_key = "${var.gossip_encryption_key}"
    }
}

resource "null_resource" "cluster-configuration" {
    count = "${var.servers}"
    connection {
        host = "${element(module.consul.private_server_ips, count.index)}"
        user = "ubuntu"
        private_key = "${var.private_key}"
        agent        = "false"
        bastion_host = "${var.bastion_public_ip}"
        bastion_user = "${var.bastion_user}"
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
            "${path.module}/scripts/setup_nginx_auth.sh",
            "${path.module}/scripts/setup_certs.sh",
            "${path.module}/scripts/consul_service.sh",
            "${path.module}/scripts/reload_nginx.sh"
        ]
    }
}
