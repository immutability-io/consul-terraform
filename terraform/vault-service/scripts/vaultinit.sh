#!/bin/bash

logger() {
  DT=$(date '+%Y/%m/%d %H:%M:%S')
  echo "$DT vault-unseal.sh: $1"
  echo "$DT vault-unseal.sh: $1" | sudo tee -a /var/log/remote-exec.log > /dev/null
}

logger "Begin script"

if ! which vault > /dev/null; then
  logger "ERROR: The vault executable was not found. This script requires vault"
  exit 1
fi

logger "Check if Vault is configured"
SLEEPTIME=1
while [ ! -f /etc/vault.d/configured ]; do
  if [ $SLEEPTIME -gt 20 ]; then
    logger "Check if Vault is configured"
    logger "ERROR: VAULT SETUP NOT COMPLETE! Manual intervention required."
    exit 2
  else
    logger "Check if Vault is configured"
    logger "Blocking until the Vault service is configured, waiting $SLEEPTIME second(s)..."
    sleep $SLEEPTIME
    SLEEPTIME=$((SLEEPTIME + 1))
  fi
done

logger "Check if the Vault service is running"
SLEEPTIME=1
while ! service vault status | grep "active (running)" > /dev/null; do
  if [ $SLEEPTIME -gt 20 ]; then
    logger "Check if the Vault service is running"
    logger "ERROR: VAULT SETUP NOT COMPLETE! Manual intervention required."
    exit 2
  else
    logger "Check if the Vault service is running"
    logger "Blocking until the Vault service is ready, waiting $SLEEPTIME second(s)..."
    sleep $SLEEPTIME
    SLEEPTIME=$((SLEEPTIME + 1))
  fi
done

logger "Check if the Vault is running on port 8200"
SLEEPTIME=1
while ! sudo netstat -tulpn | grep 8200 > /dev/null; do
  if [ $SLEEPTIME -gt 20 ]; then
    logger "Check if the Vault is running on port 8200"
    logger "ERROR: VAULT SETUP NOT COMPLETE! Manual intervention required."
    exit 2
  else
    logger "Check if the Vault is running on port 8200"
    logger "Blocking until the Vault service is ready, waiting $SLEEPTIME second(s)..."
    sleep $SLEEPTIME
    SLEEPTIME=$((SLEEPTIME + 1))
  fi
done

logger "Setting variables"
CONSUL=http://127.0.0.1:8500
export VAULT_ADDR=https://`uname -n`.ec2.internal:8200

logger "Check to see if vault is initialized"
vault status
if [[ $? -eq 2 ]] ; then
    exit 0
fi

logger "Attempting Vault initialization"

KEYBASE=(`echo "$1" | sed "s/,/ /g"`)
KEYSHARES=${#KEYBASE[@]}
vault init -key-shares=$KEYSHARES -key-threshold=$2 | tee /tmp/vault.init > /dev/null

export ROOT_TOKEN=$(cat /tmp/vault.init | grep '^Initial' | awk '{print $4}')
logger "Store master keys in Consul for operator to retrieve and remove"
COUNTER=0
cat /tmp/vault.init | grep '^Unseal' | awk '{print $4}' | for key in $(cat -); do
  logger "Saving service/vault/${KEYBASE[COUNTER]}-unseal-key"
  vault unseal $key
  keybase encrypt ${KEYBASE[COUNTER]} -m $key -o /tmp/${KEYBASE[COUNTER]}.txt
  logger $(
    curl -X PUT "$CONSUL/v1/kv/service/vault/${KEYBASE[COUNTER]}-unseal-key" -d @/tmp/${KEYBASE[COUNTER]}.txt
  )
  logger "Saving service/vault/${KEYBASE[COUNTER]}-root-token"
  keybase encrypt ${KEYBASE[COUNTER]} -m $ROOT_TOKEN -o /tmp/${KEYBASE[COUNTER]}.root.txt
  logger $(
    curl -X PUT "$CONSUL/v1/kv/service/vault/${KEYBASE[COUNTER]}-root-token" -d @/tmp/${KEYBASE[COUNTER]}.root.txt
  )
  logger "Remove ${KEYBASE[COUNTER]}'s copy of the ROOT_TOKEN from environment"
  logger $(
    shred -u -z /tmp/${KEYBASE[COUNTER]}.root.txt
  )
  logger "Remove ${KEYBASE[COUNTER]}'s Key Share from environment"
  logger $(
    shred -u -z /tmp/${KEYBASE[COUNTER]}.txt
  )
  COUNTER=$((COUNTER + 1))
done

logger "Remove master keys from disk"
logger $(
  shred -u -z /tmp/vault.init
)
