#!/usr/bin/env bash
set -e

if [ ! -d "/etc/consul.d" ]; then
  sudo mkdir /etc/consul.d
fi
if [ ! -d "/etc/service" ]; then
  sudo mkdir /etc/service
fi

echo "Create health check..."
sudo mkdir /usr/share/nginx/html/health
sudo cp /usr/share/nginx/html/index.* /usr/share/nginx/html/health

echo "Download website-health ..."
cd /usr/share/nginx/html
sudo git clone ${website_repo}

echo "Registering website with Consul..."


cat >/tmp/website.json << EOF
{
  "service": {
    "name": "website",
    "port": 443,
    "tags": ["website", "urlprefix-/website"],
    "check": {
      "id": "website-health",
      "name": "Running on port 443",
      "http": "https://localhost/health/index.html",
      "interval": "10s",
      "timeout": "1s"
    }
  }
}
EOF

sudo chmod 777 /tmp/website.json
sudo mv /tmp/website.json /etc/consul.d

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
