output "public_server_ips" {
  value = ["${aws_instance.consul-node.*.public_ip}"]
}

output "private_server_ips" {
  value = ["${aws_instance.consul-node.*.private_ip}"]
}

output "instance_ids" {
  value = ["${aws_instance.consul-node.*.id}"]
}
