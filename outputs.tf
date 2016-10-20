
output "public_server_ips" {
    value = "${module.consul-cluster.public_server_ips}"
}

output "private_server_ips" {
    value = "${module.consul-cluster.private_server_ips}"
}

output "security_group_id" {
    value = "${module.consul-cluster.security_group_id}"
}
