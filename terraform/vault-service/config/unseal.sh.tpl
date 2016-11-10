#!/bin/bash
set -e

VAULTHOST=`uname -n`.ec2.internal:8200

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
cget() { curl -sf "$CONSUL/v1/kv/service/vault/$1?raw"; }

logger "Check if Vault's been initialized"
if [ ! $(cget root-token) ]; then
  logger "Initializing Vault"
  logger $(
    vault init | tee /tmp/vault.init > /dev/null
  )

  logger "Store master keys in Consul for operator to retrieve and remove"
  COUNTER=1
  cat /tmp/vault.init | grep '^Unseal' | awk '{print $4}' | for key in $(cat -); do
    logger "Saving service/vault/unseal-key-$COUNTER"
    logger $(
      curl -fX PUT "$CONSUL/v1/kv/service/vault/unseal-key-$COUNTER" -d $key
    )
    COUNTER=$((COUNTER + 1))
  done

  logger "export ROOT_TOKEN"
  export ROOT_TOKEN=$(cat /tmp/vault.init | grep '^Initial' | awk '{print $4}')

  logger "Saving service/vault/root-token"
  logger $(
    curl -fX PUT "$CONSUL/v1/kv/service/vault/root-token" -d $ROOT_TOKEN
  )

  logger "Remove master keys from disk"
  logger $(
    shred -u -z /tmp/vault.init
  )
else
  logger "Vault has already been initialized, skipping."
fi

logger "Checking if Vault is already unsealed"
if vault status | grep "Sealed: false" > /dev/null; then
  logger "Vault is already unsealed"
else
  logger "Unsealing Vault"
  vault unseal $(cget unseal-key-1)
  vault unseal $(cget unseal-key-2)
  vault unseal $(cget unseal-key-3)
fi

logger "--Vault Status--"
logger "$(vault status)"

logger "Done"

instructions() {
  cat <<EOF

We use an instance of HashiCorp Vault for secrets management.

It has been automatically initialized and unsealed once. Future unsealing must
be done manually.

The unseal keys and root token have been temporarily stored in Consul K/V.

  /service/vault/root-token
  /service/vault/unseal-key-{1..5}

Please securely distribute and record these secrets and remove them from Consul.
EOF
}

instructions
