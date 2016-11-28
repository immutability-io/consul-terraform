#!/usr/bin/env bash

if [ ${#@} == 0 ]; then
    echo "Usage: source /vagrant/vagrant_scripts/setup_vault.sh \$param1"
    echo "* param1: sets allowed_domains.  An example could be example.com.  Another example: example.com,example.net"
    return 1
fi

echo "Setting up Vault with allowed domains: $DOMAIN"
logger() {
  DT=$(date '+%Y/%m/%d %H:%M:%S')
  echo "$DT setup_vault.sh: $1"
  echo "$DT setup_vault.sh: $1" | sudo tee -a /var/log/remote-exec.log > /dev/null
}

logger "Begin script"

if ! which vault > /dev/null; then
  logger "ERROR: The vault executable was not found. This script requires vault"
  exit 1
fi

logger "Check if the Vault service is running"
SLEEPTIME=1
while ! service vault status | grep "active (running)" > /dev/null; do
  if [ $SLEEPTIME -gt 20 ]; then
    logger "Check if the Vault service is running"
    logger "ERROR: VAULT SETUP NOT COMPLETE! Manual intervention required."
    exit 2
  else
    logger "Check if the Vault service is running"
    logger "Blocking until the Vault service is ready, waiting $SLEEPTIME second(s)..."
    sleep $SLEEPTIME
    SLEEPTIME=$((SLEEPTIME + 1))
  fi
done

logger "Check if the Vault is running on port 8200"
SLEEPTIME=1
while ! sudo netstat -tulpn | grep 8200 > /dev/null; do
  if [ $SLEEPTIME -gt 20 ]; then
    logger "Check if the Vault is running on port 8200"
    logger "ERROR: VAULT SETUP NOT COMPLETE! Manual intervention required."
    exit 2
  else
    logger "Check if the Vault is running on port 8200"
    logger "Blocking until the Vault service is ready, waiting $SLEEPTIME second(s)..."
    sleep $SLEEPTIME
    SLEEPTIME=$((SLEEPTIME + 1))
  fi
done

logger "Setting variables"

export VAULT_ADDR=https://127.0.0.1:8200

logger "Check to see if vault is initialized"
vault status
if [[ $? -eq 2 ]] ; then
    exit 0
fi

logger "Attempting Vault initialization"

vault init -key-shares=5 -key-threshold=3 | tee /vagrant/vagrant_scripts/vault.init > /dev/null

export VAULT_TOKEN=$(cat /vagrant/vagrant_scripts/vault.init | grep '^Initial' | awk '{print $4}')

COUNTER=0
cat /vagrant/vagrant_scripts/vault.init | grep '^Unseal' | awk '{print $4}' | for key in $(cat -); do
  vault unseal $key
  COUNTER=$((COUNTER + 1))
done

logger "Use Vault as CA with allowed domains: $1"

vault mount -path=vault_root -description="Vault Root CA" -max-lease-ttl=87600h pki
vault write -format=json vault_root/root/generate/internal common_name="Vault Root CA" ttl=87600h key_bits=4096 exclude_cn_from_sans=true | jq -r .data.issuing_ca | cat > root.crt
vault write vault_root/config/urls issuing_certificates="https://127.0.0.1:8200/v1/vault_root"
vault mount -path=vault_intermediate -description="Vault Intermediate CA" -max-lease-ttl=26280h pki
vault write -format=json vault_intermediate/intermediate/generate/internal common_name="Vault Intermediate CA" ttl=26280h key_bits=4096 exclude_cn_from_sans=true | jq -r .data.csr | cat > vault_intermediate.csr
vault write -format=json vault_root/root/sign-intermediate csr=@vault_intermediate.csr common_name="Vault Intermediate CA" ttl=8760h | jq -r .data.certificate | cat > vault_intermediate.crt
vault write vault_intermediate/intermediate/set-signed certificate=@vault_intermediate.crt
vault write vault_intermediate/config/urls issuing_certificates="https://127.0.0.1:8200/v1/vault_intermediate/ca"  crl_distribution_points="https://127.0.0.1:8200/v1/vault_intermediate/crl"
vault write vault_intermediate/roles/web_server key_bits=2048 max_ttl=8760h allowed_domains="ec2.internal,service.consul,$1" allow_bare_domains=true allow_subdomains=true allow_ip_sans=true

rm root.crt vault_intermediate.crt vault_intermediate.csr
