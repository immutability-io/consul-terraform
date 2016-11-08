variable "tagName" {
    default = "elb"
    description = "Name tag for the elb"
}

variable "vpc_id" {
    description = "The VPC to use."
}

variable "subnet_ids" {
    description = "Subnets for your elb."
}

variable "vpc_cidr" {
}

variable "ssl_certificate_id" {
    description = "The ARN to the certificate"
}

variable "instance_ids" {
    type = "list"
    description = "The instance_ids to use for the ELB."
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
