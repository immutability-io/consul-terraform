output "server_address" {
  value = "${aws_instance.server.0.private_ip}"
  value = "${aws_instance.server.1.private_ip}"
  value = "${aws_instance.server.2.private_ip}"
}
