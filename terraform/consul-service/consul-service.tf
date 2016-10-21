
data "template_file" "template-consul-client-config" {
    template = "${file("${path.module}/config/client_consul_config.tpl")}"
    vars {
        retry_join = "${join("\",\"", var.consul_cluster_ips)}"
        datacenter = "${var.datacenter}"
        gossip_encryption_key = "${var.gossip_encryption_key}"
    }
}

resource "aws_instance" "consul-service"
{
    ami = "${var.ami}"
    count = "${var.service_count}"
    instance_type = "${var.instance_type}"
    key_name = "${var.key_name}"
    subnet_id = "${var.subnet_id}"
    associate_public_ip_address = "${var.associate_public_ip_address}"
    vpc_security_group_ids = ["${var.security_group_id}"]

    connection
    {
        user = "ubuntu"
        private_key = "${var.private_key}"
    }

    tags
    {
        Name = "consul-service-${count.index}"
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
        source = "${var.service_config}"
        destination = "/tmp/service.json"
    }

    provisioner "file" {
        source = "${var.root_certificate}"
        destination = "/tmp/root.crt"
    }

    provisioner "file" {
        source = "${path.module}/config/rest_service.conf"
        destination = "/tmp/rest_service.conf"
    }

    provisioner "file" {
        source = "${path.module}/config/upstart.conf"
        destination = "/tmp/upstart.conf"
    }

    provisioner "remote-exec" {
        scripts = [
            "./scripts/stop_nginx.sh",
            "./scripts/install_rest_service.sh ${var.rest_service_url}",
            "./scripts/setup_certs.sh",
            "./scripts/rest_service.sh"
        ]
    }
}
