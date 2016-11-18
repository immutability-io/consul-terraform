
output "private_server_ips" {
  value = ["${aws_instance.website.*.private_ip}"]
}

output "public_server_ips" {
  value = ["${aws_instance.website.*.public_ip}"]
}

output "instance_ids" {
  value = ["${aws_instance.website.*.id}"]
}
