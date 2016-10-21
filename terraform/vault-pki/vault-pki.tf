
resource "null_resource" "issue-certificate" {
    provisioner "local-exec" {
        command = <<EOT
        VAULT_TOKEN=${var.vault_token} vault write -address=${var.vault_addr} -format=json vault_intermediate/issue/web_server common_name="${var.common_name}"  ip_sans="${var.ip_sans}" ttl=720h > ./tmp.json
EOT
    }
    provisioner "local-exec" {
        command = "cat ./tmp.json | jq -r .data.certificate | cat > ${var.certificate}"
    }
    provisioner "local-exec" {
        command = "cat ./tmp.json | jq -r .data.issuing_ca | cat > ${var.issuer_certificate}"
    }
    provisioner "local-exec" {
        command = "cat ./tmp.json | jq -r .data.private_key | cat > ${var.private_key}"
    }
}
