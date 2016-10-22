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

variable "service_config" {
    description = "The name/path of the consul config file for the service."
}

variable "service_count" {
    description = "Number of instances."
}

variable "rest_service_url" {
    default = "https://github.com/Immutability-io/go-rest/releases/download/v0.0.4/go-rest"
    description = "The url of the service single file executable (think golang)."
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

variable "consul_certificate" {
    description = "The certificate use for the consul cluster."
}

variable "consul_key" {
    description = "The key to use for the consul cluster."
}


variable "vpc_id" {
    description = "The VPC to use for the consul cluster."
}

variable "servers" {
    default = "3"
    description = "The number of Consul servers to launch."
}

variable "ingress_22" {
    default = "0.0.0.0/0"
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
