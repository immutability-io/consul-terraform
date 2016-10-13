#!/usr/bin/env bash
set -e

echo "Setup nginx authentication"
sudo chown root:root /tmp/.htpasswd
sudo mv /tmp/.htpasswd /etc/nginx/.htpasswd
sudo chmod 0644 /etc/nginx/.htpasswd
