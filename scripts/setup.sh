#!/usr/bin/env bash
set -e

sudo chown root:root /tmp/root.crt
sudo mv /tmp/root.crt /etc/consul.d/root.crt
sudo chmod 0644 /etc/consul.d/root.crt
sudo chown root:root /tmp/consul.*
sudo mv /tmp/consul.crt /etc/consul.d/consul.*
sudo chmod 0644 /etc/consul.d/consul.*
