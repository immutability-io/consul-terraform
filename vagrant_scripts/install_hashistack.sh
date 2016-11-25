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
  rm ./$1.zip
}

echo -e "\n[hashi tools] grabbing...\n";

grab vault 0.6.2
grab terraform 0.8.0-rc1
grab consul 0.7.1
grab nomad 0.5.0
grab packer 0.12.0

echo -e "\n[hashi tools] grabbing completed ;) \n";
