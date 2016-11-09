
output "private_server_ips" {
  value = ["${aws_instance.vault-service.*.private_ip}"]
}

output "public_server_ips" {
  value = ["${aws_instance.vault-service.*.public_ip}"]
}
