#!/usr/bin/env bash
set -e


echo "Starting Consul using upstart..."
sudo start consul
echo "Starting Vault service using upstart..."
sudo start vault
