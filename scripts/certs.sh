terraform apply -target=module.vault-certificates,module.consul-certificates,module.website-certificates,login-certificates,service-certificates,module.fabio-certificates -var-file=$1
