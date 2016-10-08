#!/usr/bin/env bash
set -e

python generate_certs.py $1 $2
export TF_VAR_gossip_encryption_key=`consul keygen`
