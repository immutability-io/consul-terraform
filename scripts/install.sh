#!/usr/bin/env bash
set -e

echo "Installing Consul data directory..."
sudo mkdir -p /opt/consul/data


# Write the flags to a temporary file
cat >/tmp/consul_flags << EOF
CONSUL_FLAGS="-client"
EOF

if [ -f /tmp/upstart.conf ];
then
  echo "Installing Upstart service..."
  sudo mkdir -p /etc/consul.d
  sudo mkdir -p /etc/service
  sudo chown root:root /tmp/upstart.conf
  sudo mv /tmp/upstart.conf /etc/init/consul.conf
  sudo chmod 0644 /etc/init/consul.conf
  sudo mv /tmp/consul_flags /etc/service/consul
  sudo chmod 0644 /etc/service/consul
else
  echo "Installing Systemd service..."
  sudo mkdir -p /etc/systemd/system/consul.d
  sudo chown root:root /tmp/consul.service
  sudo mv /tmp/consul.service /etc/systemd/system/consul.service
  sudo chmod 0644 /etc/systemd/system/consul.service
  sudo mv /tmp/consul_flags /etc/sysconfig/consul
  sudo chown root:root /etc/sysconfig/consul
  sudo chmod 0644 /etc/sysconfig/consul
fi