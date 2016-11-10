
resource "aws_instance" "consul-node" {
    ami = "${var.ami}"
    instance_type = "${var.instance_type}"
    key_name = "${var.key_name}"
    count = "${var.servers}"
    subnet_id = "${var.subnet_id}"
    associate_public_ip_address = "${var.associate_public_ip_address}"
    vpc_security_group_ids = ["${aws_security_group.consul-node.id}"]

    connection {
        user          = "ubuntu"
        host          = "${self.private_ip}"
        private_key   = "${var.private_key}"
        agent         = "false"
        bastion_host  = "${var.bastion_public_ip}"
        bastion_user  = "${var.bastion_user}"
    }

    #Instance tags
    tags {
      Name = "${var.tagName}-${count.index}"
      Finance = "${var.tagFinance}"
      OwnerEmail = "${var.tagOwnerEmail}"
      Schedule = "${var.tagSchedule}"
      BusinessJustification = "${var.tagBusinessJustification}"
      AutoStart = "${var.tagAutoStart}"
    }

    provisioner "file" {
        source = "${path.module}/config/consul.service"
        destination = "/tmp/consul.service"
    }

    provisioner "file" {
        source = "${path.module}/config/nginx.conf"
        destination = "/tmp/nginx.conf"
    }

    provisioner "remote-exec" {
        scripts =
        [
            "${path.module}/scripts/install.sh"
        ]
    }
}


resource "aws_security_group" "consul-node" {
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

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}
