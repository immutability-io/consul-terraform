#!/usr/bin/env bash
set -e

echo "Registering service with Consul..."
sudo chmod 777 /tmp/service.json
sudo mv /tmp/service.json /etc/consul.d

echo "Installing service..."
sudo chmod 777 /tmp/rest_service
sudo mv /tmp/rest_service /usr/local/bin

echo "Running service..."
sudo exec /usr/local/bin/rest_service &
echo "Service launched..."
