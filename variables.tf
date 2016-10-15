variable "ami" {
}

variable "key_name" {
    description = "SSH key name in your AWS account for AWS instances."
}

variable "services" {
    description = "Number of service instances."
}

variable "rest_service" {
    description = "Sample REST service."
}

variable "service_config" {
    description = "Sample REST service."
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

variable "consul_template" {
    description = "Name of consul template."
}

variable "client_consul_template" {
    description = "Name of client consul template."
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
