#!/bin/bash

logger() {
  DT=$(date '+%Y/%m/%d %H:%M:%S')
  echo "$DT use_vault_as_ca.sh: $1"
  echo "$DT use_vault_as_ca.sh: $1" | sudo tee -a /var/log/remote-exec.log > /dev/null
}

echo "Use Vault as CA with allowed domains: $2"

export VAULT_ADDR=https://`uname -n`.ec2.internal:8200
export CONSUL_VAULT_ADDR=https://vault.service.consul:8200
export VAULT_TOKEN=$1
export CONSUL=http://127.0.0.1:8500


vault auth-enable -path=immutability aws-ec2
