
resource "null_resource" "issue-certificate" {
    provisioner "local-exec" {
        command = <<EOT
        VAULT_TOKEN=${var.vault_token} vault write -address=${var.vault_addr} -format=json vault_intermediate/issue/web_server common_name="${var.common_name}" alt_names="${var.alt_names}" ip_sans="${var.ip_sans}" ttl=720h > ${var.temp_file}
EOT
    }
    provisioner "local-exec" {
        command = "cat ${var.temp_file} | jq -r .data.certificate | cat > ${var.certificate}"
    }
    provisioner "local-exec" {
        command = "cat ${var.temp_file} | jq -r .data.issuing_ca | cat > ${var.issuer_certificate}"
    }
    provisioner "local-exec" {
        command = "cat ${var.temp_file} | jq -r .data.private_key | cat > ${var.private_key}"
    }
    provisioner "local-exec" {
        command = "rm ${var.temp_file}"
    }
}
