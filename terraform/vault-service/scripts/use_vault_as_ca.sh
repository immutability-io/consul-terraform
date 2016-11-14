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
logger $(vault mount -path=vault_root -description="Vault Root CA" -max-lease-ttl=87600h pki)
logger $(vault write -format=json vault_root/root/generate/internal common_name="Vault Root CA" ttl=87600h key_bits=4096 exclude_cn_from_sans=true | jq -r .data.issuing_ca | cat > /tmp/root.crt)
logger $(vault write vault_root/config/urls issuing_certificates="https://$CONSUL_VAULT_ADDR/v1/vault_root")
logger $(vault mount -path=vault_intermediate -description="Vault Intermediate CA" -max-lease-ttl=26280h pki)
logger $(vault write -format=json vault_intermediate/intermediate/generate/internal common_name="Vault Intermediate CA" ttl=26280h key_bits=4096 exclude_cn_from_sans=true | jq -r .data.csr | cat > /tmp/vault_intermediate.csr)
logger $(vault write -format=json vault_root/root/sign-intermediate csr=@/tmp/vault_intermediate.csr common_name="Vault Intermediate CA" ttl=8760h | jq -r .data.certificate | cat > /tmp/vault_intermediate.crt)
logger $(vault write vault_intermediate/intermediate/set-signed certificate=@/tmp/vault_intermediate.crt)
logger $(vault write vault_intermediate/config/urls issuing_certificates="https://$CONSUL_VAULT_ADDR/v1/vault_intermediate/ca"  crl_distribution_points="https://$CONSUL_VAULT_ADDR/v1/vault_intermediate/crl")
logger $(vault write vault_intermediate/roles/web_server key_bits=2048 max_ttl=8760h allowed_domains="ec2.internal,service.consul,$2" allow_subdomains=true allow_ip_sans=true)

logger $(
  curl -X PUT "$CONSUL/v1/kv/service/vault/root-cert" -d @/tmp/root.crt
)
logger $(
  curl -X PUT "$CONSUL/v1/kv/service/vault/intermediate-cert" -d @/tmp/vault_intermediate.crt
)
