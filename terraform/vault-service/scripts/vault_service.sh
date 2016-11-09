#!/usr/bin/env bash
set -e


echo "Starting Consul using upstart..."
sudo systemctl start consul
echo "Starting Vault service using upstart..."
echo $(date '+%s') | sudo tee -a /etc/vault.d/configured > /dev/null
sudo systemctl start vault
