#!/usr/bin/env bash
set -e

echo "Registering REST service with Consul..."
sudo chmod 777 /tmp/service.json
sudo mv /tmp/service.json /etc/consul.d

echo "Installing REST service..."
sudo chmod 777 /tmp/rest_service
sudo mv /tmp/rest_service /usr/local/bin

echo "Installing Upstart REST service..."
sudo chown root:root /tmp/rest_service.conf
sudo mv /tmp/rest_service.conf /etc/init/rest_service.conf
sudo chmod 0644 /etc/init/rest_service.conf
