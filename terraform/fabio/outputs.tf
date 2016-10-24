
output "public_server_ips" {
  value = ["${aws_instance.fabio.*.public_ip}"]
}

output "private_server_ips" {
  value = ["${aws_instance.fabio.*.private_ip}"]
}
