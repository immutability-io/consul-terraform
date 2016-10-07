output "server_addresses" {
  value = ["${aws_instance.server.*.private_ip}"]
}
