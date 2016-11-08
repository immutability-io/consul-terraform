#!/usr/bin/env bash
set -e


echo "Starting Consul using Systemd..."
sudo service consul start
echo "Starting REST service using upstart..."
sudo start rest_service
