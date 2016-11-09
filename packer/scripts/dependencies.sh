#!/bin/bash
set -e

logger() {
  DT=$(date '+%Y/%m/%d %H:%M:%S')
  echo "$DT dependencies.sh: $1"
}

logger "Executing"

logger "Install dependencies"
apt-get -y update
apt-get -y install curl unzip gunzip wget nginx apache2-utils git jq
apt-get -y update
apt-get upgrade -y
apt-get dist-upgrade -y

logger "Completed"
