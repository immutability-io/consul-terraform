
output "private_server_ips" {
  value = ["${aws_instance.consul-service.*.private_ip}"]
}

output "public_server_ips" {
  value = ["${aws_instance.consul-service.*.public_ip}"]
}
