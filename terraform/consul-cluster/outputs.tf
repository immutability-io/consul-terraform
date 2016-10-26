
output "public_server_ips" {
    value = "${module.consul.public_server_ips}"
}

output "private_server_ips" {
    value = "${module.consul.private_server_ips}"
}

output "instance_ids" {
    value = "${module.consul.instance_ids}"
}
