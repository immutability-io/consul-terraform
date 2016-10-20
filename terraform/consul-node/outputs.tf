output "public_server_ips" {
  value = ["${aws_instance.server.*.public_ip}"]
}

output "private_server_ips" {
  value = ["${aws_instance.server.*.private_ip}"]
}

output "security_group_id" {
  value = "${aws_security_group.consul.id}"
}
