vault mount -path=vault_root -description="Vault Root CA" -max-lease-ttl=87600h pki
vault write -format=json vault_root/root/generate/internal common_name="Vault Root CA" ttl=87600h key_bits=4096 exclude_cn_from_sans=true | jq -r .data.issuing_ca | cat > root.crt
vault write vault_root/config/urls issuing_certificates="https://127.0.0.1:8200/v1/vault_root"
vault mount -path=vault_intermediate -description="Vault Intermediate CA" -max-lease-ttl=26280h pki
vault write -format=json vault_intermediate/intermediate/generate/internal common_name="Vault Intermediate CA" ttl=26280h key_bits=4096 exclude_cn_from_sans=true | jq -r .data.csr | cat > vault_intermediate.csr
vault write -format=json vault_root/root/sign-intermediate csr=@vault_intermediate.csr common_name="Vault Intermediate CA" ttl=8760h | jq -r .data.certificate | cat > vault_intermediate.crt
vault write vault_intermediate/intermediate/set-signed certificate=@vault_intermediate.crt
vault write vault_intermediate/config/urls issuing_certificates="https://127.0.0.1:8200/v1/vault_intermediate/ca"  crl_distribution_points="https://127.0.0.1:8200/v1/vault_intermediate/crl"
vault write vault_intermediate/roles/web_server key_bits=2048 max_ttl=8760h allowed_domains="ec2.internal,immutability.io,immutability.org" allow_bare_domains=true allow_subdomains=true allow_ip_sans=true
vault write -format=json vault_intermediate/issue/web_server common_name="*.ec2.internal" alt_names="" ip_sans="127.0.0.1" ttl=720h > ./tmp.json
