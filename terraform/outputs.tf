output "server_ips" {
  value = ["${aws_instance.server.*.private_ip}"]
}
