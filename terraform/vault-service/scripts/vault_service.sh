#!/usr/bin/env bash
set -e

echo "Starting Consul ..."
sudo service consul start
echo "Starting Vault service..."
echo $(date '+%s') | sudo tee -a /etc/vault.d/configured > /dev/null
sudo service vault start
