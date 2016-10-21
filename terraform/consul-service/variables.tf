
variable "key_name" {
    description = "SSH key name in your AWS account for AWS instances."
}

variable "root_certificate" {
    description = "The root certificate for the consul cluster."
}

variable "consul_cluster_ips" {
    description = "List of consul cluster IPs."
}

variable "associate_public_ip_address" {
    description = "Create public IP."
    default = false
}

variable "client_consul_template" {
    default = "config/client_consul_config.tpl"
    description = "Consul configuration template."
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

variable "service_config" {
    description = "The name/path of the consul config file for the service."
}

variable "rest_service_url" {
    default = "https://github.com/Immutability-io/go-rest/releases/download/v0.0.2/go-rest"
    description = "The url of the service single file executable (think golang)."
}

variable "rest_service_conf" {
    default = "scripts/rest_service.conf"
    description = "The name/path of the service config (health check)."
}

variable "service_upstart_conf" {
    default = "scripts/upstart.conf"
    description = "The name/path of the service upstart script."
}

variable "security_group_id" {
    description = "Consul security_group_id."
}

variable "ingress_22" {
    default = "0.0.0.0/0"
    description = "The number of Consul servers to launch."
}

variable "vpc_id" {
    description = "The VPC to use for the consul cluster."
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
