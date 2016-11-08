
output "consul_cluster_private_ips" {
    value = "${module.consul-cluster.private_server_ips}"
}

output "consul_service_private_ips" {
    value = "${module.consul-service.private_server_ips}"
}

output "bastion" {
    value = "${module.bastion.user}@${module.bastion.public_ip}"
}

output "consul_ui" {
    value = "https://${aws_route53_record.consul.name}/ui"
}

output "fabio_private_ips" {
    value = "${module.fabio.private_server_ips}"
}

output "fabio_public_ips" {
    value = "${module.fabio.public_server_ips}"
}

output "fabio_ui_a" {
    value = "https://${aws_route53_record.fabio_a.name}/routes"
}
output "fabio_ui_b" {
    value = "https://${aws_route53_record.fabio_b.name}/routes"
}
