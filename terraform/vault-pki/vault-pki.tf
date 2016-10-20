
resource "null_resource" "issue-certificate" {
    provisioner "local-exec" {
        command = <<EOT
        VAULT_TOKEN=${var.vault-token}
        vault write -format=json vault_intermediate/issue/web_server common_name="${var.common-name}"  ip_sans="${var.ip-sans}" ttl=720h > ./tmp.json
EOT
    }
}
