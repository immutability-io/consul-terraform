variable "ami" {
}

variable "key_name" {
    description = "SSH key name in your AWS account for AWS instances."
}

variable "private_key" {
    description = "Path to the private key specified by key_name."
}

variable "gossip_encryption_key" {
    description = "Result of consul keygen."
}

variable "password_file" {
    description = "Result sudo htpasswd -c .htpasswd admin."
}

variable "associate_public_ip_address" {
    description = "Create public IP."
    default = false
}

variable "service_count" {
    description = "Number of instances."
}

variable "region" {
    default = "us-east-1"
    description = "The region of AWS, for AMI lookups."
}

variable "subnet_id" {
    description = "The Subnet to use for the consul cluster."
}

variable "root_certificate" {
    description = "The root certificate for the consul cluster."
}

variable "vault_root_certificate" {
    description = "The root certificate for the vault cluster."
}

variable "consul_certificate" {
    description = "The certificate use for the consul cluster."
}

variable "consul_key" {
    description = "The key to use for the consul cluster."
}

variable "vault_certificate" {
    description = "The certificate use for the vault cluster."
}

variable "vault_key" {
    description = "The key to use for the vault cluster."
}

variable "vpc_id" {
    description = "The VPC to use for the consul cluster."
}

variable "vpc_cidr"       {
    description = "The VPC CIDR block."
}

variable "servers" {
    default = "3"
    description = "The number of Consul servers to launch."
}

variable "datacenter" {
    description = "Name of consul datacenter."
}

variable "instance_type" {
    default = "t2.micro"
    description = "AWS Instance type, if you change, make sure it is compatible with AMI, not all AMIs allow all instance types "
}

variable "tagName" {
    default = "consul-server"
    description = "Name tag for the servers"
}


variable "unique_prefix" {
    default = "unset_unique_prefix"
    description = "Prefix for all resources"
}

variable "tagFinance" {
    description = "Finance tag for the servers"
}

variable "tagOwnerEmail" {
    description = "Email tag for the servers"
}

variable "tagSchedule" {
    default = "AlwaysUp"
    description = "Schedule tag for the servers"
}

variable "tagBusinessJustification" {
    default = "Short lived instance that will auto terminate"
    description = "BusinessJustification tag for the servers"
}

variable "tagAutoStart" {
    default = "Off"
    description = "AutoStart tag for the servers"
}

variable "common_name" {
    description = "The CN for the certificate."
}

variable "alt_names" {
    description = "The Subject Alt Names for the certificate."
}

variable "ip_sans" {
    description = "The Subject Alt Names (IP) for the certificate."
}

variable "vault_token" {
    description = "The vault token."
}

variable "vault_addr" {
    default = "https://127.0.0.1:8200"
    description = "The vault address."
}

variable "aws_route53_zone_id" {
    description = "The Hosted Zone ID."
}

variable "domain_name" {
    description = "The domain name."
}

variable "keybase_keys" {
    description = "Names of Keybase keys to encrypt unseal keys."
}

variable "key_threshold" {
    description = "Number of unseal keys to require."
}

variable "s3_tfstate_bucket" {
  description = "Bucket for remote tfstate"
}
