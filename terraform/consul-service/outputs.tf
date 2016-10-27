
output "private_server_ips" {
  value = ["${aws_instance.consul-service.*.private_ip}"]
}
