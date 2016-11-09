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
echo "Installing Systemd service..."
if [ ! -d "/etc/sysconfig" ]; then
  sudo mkdir -p /etc/sysconfig
fi

echo "Registering Vault with Consul..."
VAULT_ADDR=`uname -n`.ec2.internal
sudo chmod 777 /tmp/vault_service.json
sed -i "s/vault_url/`echo $VAULT_ADDR`/g" /tmp/vault_service.json
sudo mv /tmp/vault_service.json /etc/consul.d

sudo chmod 777 /tmp/vault.json
sed -i "s/vault_ip/`ifconfig eth0 | grep "inet " | awk -F'[: ]+' '{ print $4 }'`/g" /tmp/vault.json
sudo mv /tmp/vault.json /etc/vault.d
echo $(date '+%s') | sudo tee -a /etc/vault.d/configured > /dev/null


echo "Installing Systemd Vault service..."
sudo chown root:root /tmp/vault.service
sudo mv /tmp/vault.service /etc/systemd/system/vault.service
sudo chmod 0644 /etc/systemd/system/vault.service
sudo systemctl daemon-reload
sudo systemctl enable vault.service

echo "Installing Consul data directory..."
sudo mkdir -p /opt/consul/data


# Write the flags to a temporary file
cat >/tmp/consul_flags << EOF
CONSUL_FLAGS="-client"
EOF

echo "Installing Consul Upstart service..."

sudo chown root:root /tmp/consul.service
sudo mv /tmp/consul.service /etc/systemd/system/consul.service
sudo chmod 0644 /etc/systemd/system/consul.service
sudo systemctl daemon-reload
sudo systemctl enable consul.service
