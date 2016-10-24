#!/usr/bin/env bash
set -e

if [ ! -d "/etc/consul.d" ]; then
  sudo mkdir /etc/consul.d
fi
if [ ! -d "/etc/service" ]; then
  sudo mkdir /etc/service
fi

echo "Download fabio ..."
sudo wget -O /tmp/fabio ${fabio_url}

echo "Installing fabio ..."
sudo chmod 777 /tmp/fabio
sudo mv /tmp/fabio /usr/local/bin

echo "Installing Upstart fabio..."
sudo chown root:root /tmp/fabio.conf
sudo mv /tmp/fabio.conf /etc/init/fabio.conf
sudo chmod 0644 /etc/init/fabio.conf

echo "Installing Consul data directory..."
sudo mkdir -p /opt/consul/data


# Write the flags to a temporary file
cat >/tmp/consul_flags << EOF
CONSUL_FLAGS="-client"
EOF

echo "Installing Upstart service..."
sudo chown root:root /tmp/upstart.conf
sudo mv /tmp/upstart.conf /etc/init/consul.conf
sudo chmod 0644 /etc/init/consul.conf
sudo mv /tmp/consul_flags /etc/service/consul
sudo chmod 0644 /etc/service/consul
