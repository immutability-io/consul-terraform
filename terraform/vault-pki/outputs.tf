output "certificate" {
  value = "${var.certificate}"
}

output "certificate_body" {
  value = "${file(var.certificate)}"
}

output "private_key" {
  value = "${var.private_key}"
}

output "private_key_body" {
  value = "${file(var.private_key)}"
}

output "issuer_certificate" {
  value = "${var.issuer_certificate}"
}
