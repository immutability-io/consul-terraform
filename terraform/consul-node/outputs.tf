output "public_server_ips" {
  value = ["${aws_instance.server.*.public_ip}"]
}

output "private_server_ips" {
  value = ["${aws_instance.server.*.private_ip}"]
}

output "instance_ids" {
  value = ["${aws_instance.server.*.id}"]
}
