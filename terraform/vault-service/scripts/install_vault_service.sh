#!/usr/bin/env bash
set -e

if [ ! -d "/etc/consul.d" ]; then
  sudo mkdir /etc/consul.d
fi
if [ ! -d "/etc/vault.d" ]; then
  sudo mkdir /etc/vault.d
fi
if [ ! -d "/etc/service" ]; then
  sudo mkdir /etc/service
fi

echo "Registering Vault with Consul..."
VAULT_ADDR=https://`uname -n`.ec2.internal:8200
sudo chmod 777 /tmp/vault_service.json
sed -i "s/vault_ip/`echo $VAULT_ADDR`/g" /tmp/vault_service.json
sudo mv /tmp/vault_service.json /etc/consul.d

sudo chmod 777 /tmp/vault.json
sed -i "s/vault_ip/`ifconfig eth0 | grep "inet " | awk -F'[: ]+' '{ print $4 }'`/g" /tmp/vault.json
sudo mv /tmp/vault.json /etc/vault.d
echo $(date '+%s') | sudo tee -a /etc/vault.d/configured > /dev/null

echo "Installing Vault Upstart..."
sudo chown root:root /tmp/vault.conf
sudo mv /tmp/vault.conf /etc/init/vault.conf
sudo chmod 0644 /etc/init/vault.conf

echo "Installing Consul data directory..."
sudo mkdir -p /opt/consul/data


# Write the flags to a temporary file
cat >/tmp/consul_flags << EOF
CONSUL_FLAGS="-client"
EOF

echo "Installing Consul Upstart service..."
sudo chown root:root /tmp/upstart.conf
sudo mv /tmp/upstart.conf /etc/init/consul.conf
sudo chmod 0644 /etc/init/consul.conf
sudo mv /tmp/consul_flags /etc/service/consul
sudo chmod 0644 /etc/service/consul
