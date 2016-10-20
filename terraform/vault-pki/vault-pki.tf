
resource "null_resource" "issue-certificate" {
    provisioner "local-exec" {
        command = <<EOT
        VAULT_TOKEN=${var.vault-token} vault write -address=${var.vault-addr} -format=json vault_intermediate/issue/web_server common_name="${var.common-name}"  ip_sans="${var.ip-sans}" ttl=720h > ./tmp.json
EOT
    }
    provisioner "local-exec" {
        command = "cat ./tmp.json | jq -r .data.certificate | cat > ./cert.crt"
    }
    provisioner "local-exec" {
        command = "cat ./tmp.json | jq -r .data.issuing_ca | cat > ./issuer.crt"
    }
    provisioner "local-exec" {
        command = "cat ./tmp.json | jq -r .data.private_key | cat > ./private.key"
    }
}
