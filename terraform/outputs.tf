output "public_server_ips" {
  value = ["${aws_instance.server.*.public_ip}"]
}

output "private_server_ips" {
  value = ["${aws_instance.server.*.private_ip}"]
}

output "web_security_group_ids" {
  value = ["${aws_security_group.consul-ui.id}"]
}
