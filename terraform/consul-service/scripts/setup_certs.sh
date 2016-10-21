#!/usr/bin/env bash
set -e



if [ ! -d "/etc/consul.d" ]; then
  sudo mkdir /etc/consul.d
fi

echo "Setup CA Certificate"
sudo chown root:root /tmp/root.crt
sudo cp /tmp/root.crt /usr/local/share/ca-certificates/
sudo update-ca-certificates
sudo mv /tmp/root.crt /etc/consul.d/root.crt
sudo chmod 0644 /etc/consul.d/root.crt

echo "Setup Consul config"
sudo chown root:root /tmp/consul.json
sudo mv /tmp/consul.json /etc/consul.d/consul.json
sudo chmod 0644 /etc/consul.d/consul.json
