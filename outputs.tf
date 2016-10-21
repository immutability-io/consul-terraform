
output "cluster_public_server_ips" {
    value = "${module.consul-cluster.public_server_ips}"
}

output "cluster_private_server_ips" {
    value = "${module.consul-cluster.private_server_ips}"
}

output "service_public_server_ips" {
    value = "${module.consul-service.public_server_ips}"
}

output "service_private_server_ips" {
    value = "${module.consul-service.private_server_ips}"
}
