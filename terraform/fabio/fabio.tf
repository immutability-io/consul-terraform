
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
    vpc_security_group_ids = ["${aws_security_group.fabio.id}"]

    connection {
        user          = "ubuntu"
        host          = "${self.private_ip}"
        private_key   = "${var.private_key}"
        agent         = "false"
        bastion_host  = "${var.bastion_public_ip}"
        bastion_user  = "${var.bastion_user}"
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
        source = "${path.module}/config/fabio.service"
        destination = "/tmp/fabio.service"
    }

    provisioner "file" {
        source = "${path.module}/config/consul.service"
        destination = "/tmp/consul.service"
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

resource "aws_security_group" "fabio" {
    name = "${var.tagName}-security-group"
    description = "Consul internal traffic + maintenance."
    vpc_id = "${var.vpc_id}"

    tags {
        Name = "${var.tagName}"
    }
    // These are for internal traffic

    ingress {
        protocol    = -1
        from_port   = 0
        to_port     = 0
        cidr_blocks = ["${var.vpc_cidr}"]
    }

    ingress {
        from_port = 9999
        to_port = 9999
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = 443
        to_port = 443
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
