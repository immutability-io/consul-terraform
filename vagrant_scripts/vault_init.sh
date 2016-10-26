curl -s -H 'Content-Type: application/json'  -X PUT -d '{"secret_shares": 5, "secret_threshold": 3}' $VAULT_ADDR/v1/sys/init | jq .
