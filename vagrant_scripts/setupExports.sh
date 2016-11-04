#!/usr/bin/env bash

#for packer
export AWS_ACCESS_KEY_ID="---insert your AWS key---"
export AWS_SECRET_ACCESS_KEY="---insert your AWS secret key---"
export DEFAULT_REGION_NAME="us-east-1"
export DEFAULT_VPC_ID="---insert your AWS VPC ID---"
export DEFAULT_AMI_ID="ami-2d39803a"
export DEFAULT_SUBNET_ID="---insert your AWS subnet---"
export DEFAULT_INSTANCE_TYPE="t2.micro"
export DEFAULT_AMI_NAME="my-consul-ami"
export PACKER_LOG=1
export PACKER_LOG_PATH=./packer.log
export DNS_LISTEN_ADDR="0.0.0.0"
export DEFAULT_AMI_NAME="consul-server"




#for terraform
export TF_VAR_ami=$DEFAULT_AMI_ID
export TF_VAR_key_name = "---insert your AWS Keypair name---"
export TF_VAR_service_config = "./config/go-rest.json"
export TF_VAR_datacenter = "my-data-center"
export TF_VAR_private_key = "---location of AWS Keypair private key---"
export TF_VAR_root_certificate = "./ssl/vault_root.cer"
export TF_VAR_consul_certificate = "./ssl/consul.cer"
export TF_VAR_consul_key = "./ssl/consul.key"
export TF_VAR_common_name = "consul.example.com"
export TF_VAR_ip_sans = "127.0.0.1"
export TF_VAR_associate_public_ip_address = "true"
export TF_VAR_region = $DEFAULT_REGION_NAME
export TF_VAR_subnet_id = $DEFAULT_SUBNET_ID
export TF_VAR_vpc_id = $DEFAULT_VPC_ID
export TF_VAR_tagFinance = "CostCenter:Project"
export TF_VAR_tagOwnerEmail = "---Your email---"
export TF_VAR_gossip_encryption_key = "--- Use `consul keygen` ---"
export TF_VAR_password_file = "./config/.htpasswd"
export TF_VAR_service_count = "3"
export TF_VAR_vault_token = $VAULT_TOKEN