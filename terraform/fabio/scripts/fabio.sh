#!/usr/bin/env bash
set -e


echo "Starting Consul using Systemd..."
sudo service start consul
echo "Starting fabio using upstart..."
sleep 10
sudo start fabio
