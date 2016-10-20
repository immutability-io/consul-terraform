
resource "null_resource" "issue-certificate" {
    provisioner "local-exec" {
        scripts = [
            "${path.module}/scripts/issue_certificate.sh ${var.vault-token} ${var.vault-addr} ${var.common-name} ${var.ip-sans} ${var.issuer-certificate} ${var.certificate} ${var.private-key}"
        ]
    }
}
