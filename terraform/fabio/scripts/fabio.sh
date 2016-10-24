#!/usr/bin/env bash
set -e


echo "Starting Consul using upstart..."
sudo start consul
echo "Starting fabio using upstart..."
sudo start fabio
echo "Running - `sudo ps -eaf | grep fabio`"
