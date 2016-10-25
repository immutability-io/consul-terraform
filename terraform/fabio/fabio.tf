
data "template_file" "template-consul-client-config" {
    template = "${file("${path.module}/config/client_consul_config.tpl")}"
    vars {
        retry_join = "${join("\",\"", var.consul_cluster_ips)}"
        datacenter = "${var.datacenter}"
        gossip_encryption_key = "${var.gossip_encryption_key}"
    }
}

data "template_file" "template-install-fabio" {
    template = "${file("${path.module}/scripts/install_fabio.sh")}"
    vars {
        fabio_url = "${var.fabio_url}"
    }
}

resource "aws_instance" "fabio"
{
    ami = "${var.ami}"
    count = "${var.service_count}"
    instance_type = "${var.instance_type}"
    key_name = "${var.key_name}"
    subnet_id = "${var.subnet_id}"
    associate_public_ip_address = "${var.associate_public_ip_address}"
    vpc_security_group_ids = ["${var.security_group_id}"]

    connection {
        user = "ubuntu"
        private_key = "${var.private_key}"
    }

    tags {
        Name = "${var.tagName}-${count.index}"
        Finance = "${var.tagFinance}"
        OwnerEmail = "${var.tagOwnerEmail}"
        Schedule = "${var.tagSchedule}"
        BusinessJustification = "${var.tagBusinessJustification}"
        AutoStart = "${var.tagAutoStart}"
    }

    provisioner "file" {
        content = "${data.template_file.template-consul-client-config.rendered}"
        destination = "/tmp/consul.json"
    }

    provisioner "file" {
        content = "${data.template_file.template-install-fabio.rendered}"
        destination = "/tmp/install_fabio.sh"
    }

    provisioner "file" {
        source = "${path.module}/config/nginx.conf"
        destination = "/tmp/nginx.conf"
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
        source = "${path.module}/config/fabio.conf"
        destination = "/tmp/fabio.conf"
    }

    provisioner "file" {
        source = "${path.module}/config/upstart.conf"
        destination = "/tmp/upstart.conf"
    }

    provisioner "remote-exec" {
        inline = [
            "chmod +x /tmp/install_fabio.sh",
            "/tmp/install_fabio.sh"
        ]
    }

    provisioner "file" {
        source = "${var.password_file}"
        destination = "/tmp/.htpasswd"
    }

    provisioner "file" {
        source = "${path.module}/config/dnsmasq.conf"
        destination = "/tmp/dnsmasq.conf"
    }

    provisioner "remote-exec" {
        scripts = [
            "${path.module}/scripts/setup_nginx_auth.sh",
            "${path.module}/scripts/setup_certs.sh",
            "${path.module}/scripts/fabio.sh",
            "${path.module}/scripts/dnsmasq.sh",
            "${path.module}/scripts/reload_nginx.sh"
        ]
    }

}
