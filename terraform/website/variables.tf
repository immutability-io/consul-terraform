
variable "bastion_public_ip" {
    description = "IP of the bastion host"
}

variable "bastion_user" {
    description = "user of the bastion host"
}

variable "key_name" {
    description = "SSH key name in your AWS account for AWS instances."
}

variable "root_certificate" {
    description = "The root certificate for the consul cluster."
}

variable "website_root_certificate" {
    description = "The root certificate for the website."
}

variable "consul_certificate" {
    description = "The certificate use for the consul cluster."
}

variable "consul_key" {
    description = "The key to use for the consul cluster."
}

variable "website_certificate" {
    description = "The certificate use for the website."
}

variable "website_key" {
    description = "The key to use for the website."
}

variable "consul_cluster_ips" {
    type = "list"
    description = "List of consul cluster IPs."
}

variable "associate_public_ip_address" {
    description = "Create public IP."
    default = false
}

variable "datacenter" {
    description = "Name of consul datacenter."
}

variable "private_key" {
    description = "Path to the private key specified by key_name."
}

variable "gossip_encryption_key" {
    description = "Result of consul keygen."
}

variable "ami" {
}

variable "service_count" {
    description = "Number of instances."
}

variable "instance_type" {
    default = "t2.micro"
    description = "AWS Instance type, if you change, make sure it is compatible with AMI, not all AMIs allow all instance types "
}

variable "subnet_id" {
    description = "The Subnet to use for the service."
}

variable "website_repo" {
    default = "https://github.com/immutability-io/website.git"
    description = "The GitHub repo of the website"
}

variable "password_file" {
    description = "Result sudo htpasswd -c .htpasswd admin."
}

variable "vpc_id" {
    description = "The VPC to use for the consul cluster."
}

variable "vpc_cidr" {
}

variable "tagName" {
    default = "fabio-router"
    description = "Name tag for the fabio servers"
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
