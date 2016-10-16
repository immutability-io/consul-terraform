#!/bin/bash
set -e

logger() {
  DT=$(date '+%Y/%m/%d %H:%M:%S')
  echo "$DT dependencies.sh: $1"
}

logger "Executing"

logger "Install dependencies"
apt-get -y update
apt-get -y install curl unzip wget nginx apache2-utils git
sudo add-apt-repository -y ppa:ubuntu-lxc/lxd-stable
sudo apt-get -y update
sudo apt-get -y install golang
logger "Completed"
