resource "aws_instance" "server" {
    ami = "${var.ami}"
    instance_type = "${var.instance_type}"
    key_name = "${var.key_name}"
    count = "${var.servers}"
    subnet_id = "${var.subnet_id}"
    associate_public_ip_address = "${var.associate_public_ip_address}"
    vpc_security_group_ids = ["${var.security_group_id}"]

    connection {
        user = "ubuntu"
        private_key = "${var.private_key}"
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
        source = "${path.module}/config/upstart.conf"
        destination = "/tmp/upstart.conf"
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
