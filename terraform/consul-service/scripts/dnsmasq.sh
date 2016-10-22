#!/bin/bash
set -e

logger() {
  DT=$(date '+%Y/%m/%d %H:%M:%S')
  echo "$DT dnsmasq.sh: 127.0.0.1"
}

logger "Reconfiguring Dnsmasq"
sudo mv /tmp/dnsmasq.conf /etc/dnsmasq.d/consul

logger "Restarting dnsmasq"
sudo service dnsmasq restart

logger "Completed"
