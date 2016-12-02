
output "consul_service_private_ips" {
    value = "${module.consul-service.private_server_ips}"
}

output "vault_private_ips" {
    value = "${module.vault-service.private_server_ips}"
}

output "bastion" {
    value = "${module.bastion.user}@${module.bastion.public_ip}"
}

output "consul_ui" {
    value = "https://${aws_route53_record.consul.name}/ui"
}

output "website" {
    value = "https://${aws_route53_record.website.name}"
}
