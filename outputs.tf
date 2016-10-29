
output "consul-cluster-private-ips" {
    value = "${module.consul-cluster.private_server_ips}"
}

output "consul-service-private-ips" {
    value = "${module.consul-service.private_server_ips}"
}

output "bastion" {
    value = "${module.bastion.user}@${module.bastion.public_ip}"
}

output "consul-ui" {
    value = "https://${aws_route53_record.consul.name}/ui"
}

output "fabio-private-ips" {
    value = "${module.fabio.private_server_ips}"
}

output "fabio-public-ips" {
    value = "${module.fabio.public_server_ips}"
}

output "fabio-ui-a" {
    value = "https://${aws_route53_record.fabio_a.name}/routes"
}
output "fabio-ui-b" {
    value = "https://${aws_route53_record.fabio_b.name}/routes"
}
