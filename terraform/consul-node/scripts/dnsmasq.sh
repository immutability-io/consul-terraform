#!/bin/bash
set -e

logger() {
  DT=$(date '+%Y/%m/%d %H:%M:%S')
  echo "$DT dnsmasq.sh: 0.0.0.0"
}

logger "Executing"

logger "Installing Dnsmasq"
sudo apt-get -qqy update
sudo apt-get -qqy upgrade
sudo apt-get -qqy install dnsmasq-base dnsmasq

logger "Configuring Dnsmasq"
sudo mv /tmp/dnsmasq.conf /etc/dnsmasq.d/consul

logger "Restarting dnsmasq"
sudo service dnsmasq start || sudo service dnsmasq restart

logger "Completed"
