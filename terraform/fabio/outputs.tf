
output "private_server_ips" {
  value = ["${aws_instance.fabio.*.private_ip}"]
}

output "public_server_ips" {
  value = ["${aws_instance.fabio.*.public_ip}"]
}

output "instance_ids" {
  value = ["${aws_instance.fabio.*.id}"]
}
