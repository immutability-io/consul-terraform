#!/usr/bin/env bash

if [ ${#@} == 0 ]; then
    echo "Usage: source /vagrant/vagrant_scripts/setup_vault.sh \$param1"
    echo "* param1: sets allowed_domains.  An example could be example.com.  Another example: example.com,example.net"
    return 1
fi

echo "Setting up Vault with allowed domains: $1"

sudo python /vagrant/vagrant_scripts/configure_vault.py > vault_secrets.txt

#for vault
export VAULT_TOKEN=`awk '$0 == "* Root token *" {i=1;next};i && i++ == 2' vault_secrets.txt`
export VAULT_ADDR="https://127.0.0.1:8200"

/vagrant/vagrant_scripts/use_vault_as_ca.sh $1
