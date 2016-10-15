#!/usr/bin/env bash
set -e

echo "Registering service with Consul..."
sudo chmod 777 /tmp/service.json
sudo mv /tmp/service.json /etc/consul.d

echo "Starting service..."
sudo chmod 777 /tmp/rest_service
sudo mv /tmp/rest_service /usr/local/bin
sudo nohup rest_service &
