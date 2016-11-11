
data "template_file" "template-consul-client-config" {
    template = "${file("${path.module}/config/client_consul_config.tpl")}"
    vars {
        retry_join = "${join("\",\"", var.consul_cluster_ips)}"
        datacenter = "${var.datacenter}"
        gossip_encryption_key = "${var.gossip_encryption_key}"
    }
}

data "template_file" "vault-unseal-script" {
    template = "${file("${path.module}/config/unseal.sh.tpl")}"
    vars {
        keybase_keys  = "${var.keybase_keys}"
        key_shares    = "${var.key_shares}"
        key_threshold = "${var.key_threshold}"
    }
}

resource "aws_instance" "vault-service" {
    ami = "${var.ami}"
    count = "${var.service_count}"
    instance_type = "${var.instance_type}"
    key_name = "${var.key_name}"
    subnet_id = "${var.subnet_id}"
    associate_public_ip_address = "${var.associate_public_ip_address}"
    vpc_security_group_ids = ["${aws_security_group.vault-service.id}"]

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
        source = "${path.module}/config/vault_service.json"
        destination = "/tmp/vault_service.json"
    }

    provisioner "file" {
        source = "${path.module}/config/vault.json"
        destination = "/tmp/vault.json"
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
        source = "${var.vault_certificate}"
        destination = "/tmp/vault.crt"
    }

    provisioner "file" {
        source = "${var.vault_key}"
        destination = "/tmp/vault.key"
    }

    provisioner "file" {
        source = "${path.module}/config/consul.service"
        destination = "/tmp/consul.service"
    }

    provisioner "file" {
        source = "${path.module}/config/vault.service"
        destination = "/tmp/vault.service"
    }

    provisioner "file" {
        source = "${path.module}/scripts/install_vault_service.sh"
        destination = "/tmp/install_vault_service.sh"
    }

    provisioner "remote-exec" {
        scripts = [
            "${path.module}/scripts/stop_nginx.sh"
        ]
    }

    provisioner "remote-exec" {
        inline = [
            "chmod +x /tmp/install_vault_service.sh",
            "/tmp/install_vault_service.sh"
        ]
    }

    provisioner "file" {
        source = "${path.module}/config/dnsmasq.conf"
        destination = "/tmp/dnsmasq.conf"
    }

    provisioner "remote-exec" {
        scripts = [
            "${path.module}/scripts/setup_certs.sh",
            "${path.module}/scripts/vault_service.sh",
            "${path.module}/scripts/dnsmasq.sh"
        ]
    }

    provisioner "remote-exec" {
        inline = "${data.template_file.vault-unseal-script.rendered}"
    }

}
resource "aws_security_group" "vault-service" {
    name = "${var.tagName}-security-group"
    description = "Vault internal traffic + maintenance."
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
        protocol    = "tcp"
        from_port   = 8080
        to_port     = 8080
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}
