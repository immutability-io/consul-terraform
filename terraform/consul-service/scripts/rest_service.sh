#!/usr/bin/env bash
set -e


echo "Starting Consul using upstart..."
sudo start consul
echo "Starting REST service using upstart..."
sudo start rest_service
