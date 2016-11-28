#!/usr/bin/env bash

set -e

function grab {
  echo "Tool: $1"
  echo "Version: $2"


  wget  --progress=bar:force -O ./$1.zip https://releases.hashicorp.com/$1/$2/$1_$2_linux_amd64.zip
  wget  --progress=bar:force -O ./$1_$2_SHA256SUMS https://releases.hashicorp.com/$1/$2/$1_$2_SHA256SUMS
  wget  --progress=bar:force -O ./$1_$2_SHA256SUMS.sig https://releases.hashicorp.com/$1/$2/$1_$2_SHA256SUMS.sig
  keybase pgp verify -d ./$1_$2_SHA256SUMS.sig -i ./$1_$2_SHA256SUMS
  if [[ $? -eq 2 ]] ; then
    echo "Keybase error!"
    exit 2
  fi
  unzip ./$1.zip
  sudo mv ./$1 /usr/local/bin/$1
  sudo chmod 0755 /usr/local/bin/$1
  sudo chown root:root /usr/local/bin/$1
  rm ./$1_$2_SHA256SUMS.sig
  rm ./$1_$2_SHA256SUMS
  rm ./$1.zip
}

echo -e "\n[hashi tools] grabbing...\n";

grab vault 0.6.2
grab consul 0.7.1
grab nomad 0.5.0
grab consul-template 0.16.0
grab consul-replicate 0.2.0
grab envconsul 0.6.1
