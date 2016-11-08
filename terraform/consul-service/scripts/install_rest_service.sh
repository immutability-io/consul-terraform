#!/usr/bin/env bash
set -e

if [ ! -d "/etc/consul.d" ]; then
  sudo mkdir /etc/consul.d
fi
if [ ! -d "/etc/service" ]; then
  sudo mkdir /etc/service
fi

echo "Download REST service..."
sudo wget --quiet -O /tmp/rest_service ${rest_service_url}

echo "Registering REST service with Consul..."
sudo chmod 777 /tmp/service.json
sudo mv /tmp/service.json /etc/consul.d

echo "Installing REST service..."
sudo chmod 777 /tmp/rest_service
sudo mv /tmp/rest_service /usr/local/bin

echo "Installing Systemd REST service..."
sudo chown root:root /tmp/rest_service.service
sudo mv /tmp/rest_service.service /etc/systemd/system/rest_service.service
sudo chmod 0644 /etc/systemd/system/rest_service.service
sudo systemctl daemon-reload
sudo systemctl enable rest_service.service

echo "Installing Consul data directory..."
sudo mkdir -p /opt/consul/data


# Write the flags to a temporary file
cat >/tmp/consul_flags << EOF
CONSUL_FLAGS="-client"
EOF

echo "Installing Consul Systemd service..."
if [ ! -d "/etc/sysconfig" ]; then
  sudo mkdir -p /etc/sysconfig
fi

sudo chown root:root /tmp/consul.service
sudo mv /tmp/consul.service /etc/systemd/system/consul.service
sudo chmod 0644 /etc/systemd/system/consul.service
sudo systemctl daemon-reload
sudo systemctl enable consul.service
