#!/usr/bin/env bash
set -e

echo "Starting service..."
sudo chmod 777 /tmp/go-rest.json
sudo mv /tmp/go-rest.json /etc/consul.d

sudo chmod 777 /tmp/rest_service
sudo mv /tmp/rest_service /usr/local/bin
sudo nohup rest_service &
