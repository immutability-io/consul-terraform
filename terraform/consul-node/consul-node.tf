resource "aws_instance" "server"
{
    ami = "${var.ami}"
    instance_type = "${var.instance_type}"
    key_name = "${var.key_name}"
    count = "${var.servers}"
    subnet_id = "${var.subnet_id}"
    associate_public_ip_address = "${var.associate_public_ip_address}"
    vpc_security_group_ids = ["${aws_security_group.consul.id}"]

    connection
    {
        user = "ubuntu"
        private_key = "${var.private_key}"
    }

    #Instance tags
    tags
    {
      Name = "${var.tagName}-${count.index}"
      Finance = "${var.tagFinance}"
      OwnerEmail = "${var.tagOwnerEmail}"
      Schedule = "${var.tagSchedule}"
      BusinessJustification = "${var.tagBusinessJustification}"
      AutoStart = "${var.tagAutoStart}"
    }

    provisioner "file"
    {
        source = "${path.module}/scripts/upstart.conf"
        destination = "/tmp/upstart.conf"
    }

    provisioner "file"
    {
        source = "${path.module}/scripts/nginx.conf"
        destination = "/tmp/nginx.conf"
    }

    provisioner "remote-exec"
    {
        scripts =
        [
            "${path.module}/scripts/install.sh",
            "${path.module}/scripts/ip_tables.sh",
            "${path.module}/scripts/dnsmasq.sh"
        ]
    }
}

resource "aws_security_group" "consul"
{
    name = "${var.tagName}-security-group"
    description = "Consul internal traffic + maintenance."
    vpc_id = "${var.vpc_id}"

    // These are for internal traffic
    ingress
    {
        from_port = 0
        to_port = 65535
        protocol = "tcp"
        self = true
    }

    ingress
    {
        from_port = 0
        to_port = 65535
        protocol = "udp"
        self = true
    }

    ingress
    {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["${var.ingress_22}"]
    }

    ingress
    {
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress
    {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}
