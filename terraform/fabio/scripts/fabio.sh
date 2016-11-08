#!/usr/bin/env bash
set -e


echo "Starting Consul using Systemd..."
sudo service consul start
echo "Starting fabio using upstart..."
sleep 10
sudo service fabio start
