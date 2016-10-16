#!/usr/bin/env bash
set -e

echo "Installing Consul data directory..."
sudo mkdir -p /opt/consul/data


# Write the flags to a temporary file
cat >/tmp/consul_flags << EOF
CONSUL_FLAGS="-client"
EOF

echo "Installing Upstart service..."

if [ ! -d "/etc/consul.d" ]; then
  sudo mkdir -p /etc/consul.d
fi
if [ ! -d "/etc/service" ]; then
  sudo mkdir -p /etc/service
fi
sudo chown root:root /tmp/upstart.conf
sudo mv /tmp/upstart.conf /etc/init/consul.conf
sudo chmod 0644 /etc/init/consul.conf
sudo mv /tmp/consul_flags /etc/service/consul
sudo chmod 0644 /etc/service/consul
