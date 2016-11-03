#!/usr/bin/env bash

sudo python /vagrant/vagrant_scripts/configure_vault.py > vault_secrets.txt

#for vault
export VAULT_TOKEN=`awk '$0 == "* Root token *" {i=1;next};i && i++ == 2' vault_secrets.txt`
export VAULT_ADDR="https://127.0.0.1:8200"

sh /vagrant/vagrant_scripts/use_vault_as_ca.sh