
terraform apply -target=module.vault-certificates -var-file=$1
terraform apply -target=module.consul-certificates -var-file=$1
terraform apply -target=module.website-certificates -var-file=$1
terraform apply -target=module.login-certificates -var-file=$1
terraform apply -target=module.service-certificates -var-file=$1
terraform apply -target=module.fabio-certificates -var-file=$1
