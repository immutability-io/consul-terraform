
output "cluster_private_server_ips" {
    value = "${module.consul-cluster.private_server_ips}"
}

output "service_private_server_ips" {
    value = "${module.consul-service.private_server_ips}"
}

output "bastion" {
    value = "${module.bastion.user}@${module.bastion.public_ip}"
}

output "consul_ui" {
    value = "https://${aws_route53_record.consul.name}/ui"
}

output "fabio_ui" {
    value = "https://${aws_route53_record.fabio.name}/routes"
}
