output "server_address" {
  value = "${aws_instance.server.0.private_ip}"
}
