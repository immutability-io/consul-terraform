output "server_address" {
  value = ["${aws_instance.server.*.private_ip}"]
}
