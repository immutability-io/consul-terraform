variable "issuer-certificate" {
    description = "The path to the issuer certificate."
}

variable "certificate" {
    description = "The path to the certificate."
}

variable "private-key" {
    description = "The path to the private key."
}

variable "common-name" {
    description = "The CN for the certificate."
}

variable "ip-sans" {
    description = "The Subject Alt Names (IP) for the certificate."
}

variable "vault-token" {
    description = "The vault token."
}

variable "vault-addr" {
    default = "https://127.0.0.1:8200"
    description = "The vault address."
}
