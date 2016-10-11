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
    }

    provisioner "file"
    {
        source = "${path.module}/scripts/upstart.conf"
        destination = "/tmp/upstart.conf"
    }

    provisioner "remote-exec"
    {
        inline =
        [
          "echo ${var.servers} > /tmp/consul-server-count",
          "echo ${aws_instance.server.0.private_ip} > /tmp/consul-server-addr"
        ]
    }
    provisioner "remote-exec"
    {
        scripts =
        [
            "${path.module}/scripts/install.sh",
            "${path.module}/scripts/ip_tables.sh"
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
        from_port = 8500
        to_port = 8500
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
