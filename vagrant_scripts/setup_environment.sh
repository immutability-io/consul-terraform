#!/usr/bin/env bash

echo -e "\n[vault environment] setup...\n";

sudo mkdir -p /export/appl/pkgs/.vault
sudo mkdir /etc/vault.d


hcl_uname=`python -c "import os;print os.uname()[1]"`
cat << EOF > /vagrant/$hcl_uname-read.hcl
path "secret/svc-accts/$hcl_uname/*" {
  capabilities = ["read"]
}
path "auth/token/lookup-self" {
  policy = "read"
}
path "auth/token/renew-self" {
  policy = "write"
}
EOF

cat << EOF > /tmp/vault.crt
-----BEGIN CERTIFICATE-----
MIIDVTCCAj2gAwIBAgIBCjANBgkqhkiG9w0BAQUFADB6MQswCQYDVQQGEwJVUzER
MA8GA1UECAwITWFyeWxhbmQxEjAQBgNVBAcMCUJhbHRpbW9yZTEVMBMGA1UECgwM
VC5Sb3dlIFByaWNlMQ8wDQYDVQQLDAZEZXZPcHMxHDAaBgNVBAMME2NhLXVidW50
dS0xNDA0LXZib3gwHhcNMTYwOTMwMTYyNTE0WhcNMTcwOTMwMTYyNTE0WjBjMRkw
FwYDVQQDDBB1YnVudHUtMTQwNC12Ym94MREwDwYDVQQIDAhNYXJ5bGFuZDELMAkG
A1UEBhMCVVMxFTATBgNVBAoMDFQuUm93ZSBQcmljZTEPMA0GA1UECwwGRGV2T3Bz
MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCvxrr2KqRTTeOAvw8/PKjGGA9C
0X7Nnp7Vlo4E3pbfGT0PKaQJhlZzF5dY5qxb0g4qzIbjaYut3ttEWEi6JFMYO4Fs
Y72laj/QAgxCyBoPWWN+KYAZ5KtufWItbuEriiKseCixvwYgxwZHpXZ09J2yeihe
X68x/mN6ijlDDKwjkQIDAQABo4GAMH4wCQYDVR0TBAIwADAdBgNVHQ4EFgQUQj5w
lVsPmEQNBHWBKFN65ra9lzIwHwYDVR0jBBgwFoAU6eMc7uYrtiZJg7q44D5HE+DJ
UdwwDwYDVR0RBAgwBocEfwAAATALBgNVHQ8EBAMCBaAwEwYDVR0lBAwwCgYIKwYB
BQUHAwEwDQYJKoZIhvcNAQEFBQADggEBAKz0hqMcKa1Lo+P7jdK00pWvS9OddQDp
vCWYa/7dGHTy2JRN2iAsssxOVewpOUg98wsLJi54rBzzMvdfbX316cNX5M9+PBqm
6b6FMgpb16eDSpHO/DY4UdB89UKKU4iNzB4nllXqidLuVH5c/SOW33qP5rqJmbDr
cLUF3tCIXhcuqt9z1RgvJQPc0od5FTA5f5BCWCzC2eJDxXI8yGSrrzyi37WmyzF5
f68wmbwsCZi4iQHt2vhVzSCv618LTJyILfoa2u1f5asTPsHsxxkNpspd9GutPI5s
EeNCHUMpdrmIETZej0boIKUffXqSb7ds8uI7BzNpJZA5igMNDr4ONsk=
-----END CERTIFICATE-----
EOF

cat << EOF > /tmp/vault.key
-----BEGIN PRIVATE KEY-----
MIICdgIBADANBgkqhkiG9w0BAQEFAASCAmAwggJcAgEAAoGBAK/GuvYqpFNN44C/
Dz88qMYYD0LRfs2entWWjgTelt8ZPQ8ppAmGVnMXl1jmrFvSDirMhuNpi63e20RY
SLokUxg7gWxjvaVqP9ACDELIGg9ZY34pgBnkq259Yi1u4SuKIqx4KLG/BiDHBkel
dnT0nbJ6KF5frzH+Y3qKOUMMrCORAgMBAAECgYAbujuPzVYyldzHWFwtW4I8DVuK
7MUV5mmjw6YPepVOCAsrsyPfJMPKT/Rd37VcnpwBgFXe1a1k9fycoViHlGdO7g0+
kqkE3if5DdXUTsq/rhfyZoyidNtjnBzz0YlEe50XS6Pkg5dmvOjUs37+trNKKG5Z
MaKIAFF8nNEkbMxAAQJBAOjLyuhMohiRvYVjuIj0SSH9s6V7WgFfaSETBHLRY0BY
/+sbtbpEn2HraFwOQD77EKZzHkicCup3wGKRn9lBGgECQQDBS/nwIoaiCjXNwpZQ
zVvQSy7xMqKhbmFkauV38uiCAqftTMUoEe1z+TRD6s0CczboP69TdC7hw30uTCHX
ImmRAkEAq382g9uwrpjvHY1RLNOJ7NiRt58ft1Mqh4sTA+LtU0I9hl5rikVzhRd/
UhHNkpgys+yqqqMKB6EgwXy2Xb5wAQJACMiNCO5os8BHBZyL/Av42hQwg+FLJo6/
ejKpTrQJAK9iNhRA+TsnURfH2jY3Lp9RpWgPbXlgD/40GAB5oS79IQJAC+IchqOT
DM2RRcwthaPYxtI6VwAP9y0P4oxqEipyZdxzGHHzxYuqCWqiLjMNLDWtxzW/D2Hm
0VM+jy1CX0dbSQ==
-----END PRIVATE KEY-----
EOF

cat << EOF > /tmp/root.crt
-----BEGIN CERTIFICATE-----
MIIDxzCCAq+gAwIBAgIJAM6ANo09S1SnMA0GCSqGSIb3DQEBCwUAMHoxCzAJBgNV
BAYTAlVTMREwDwYDVQQIDAhNYXJ5bGFuZDESMBAGA1UEBwwJQmFsdGltb3JlMRUw
EwYDVQQKDAxULlJvd2UgUHJpY2UxDzANBgNVBAsMBkRldk9wczEcMBoGA1UEAwwT
Y2EtdWJ1bnR1LTE0MDQtdmJveDAeFw0xNjA5MzAxNjIzMTRaFw0yNjA5MjgxNjIz
MTRaMHoxCzAJBgNVBAYTAlVTMREwDwYDVQQIDAhNYXJ5bGFuZDESMBAGA1UEBwwJ
QmFsdGltb3JlMRUwEwYDVQQKDAxULlJvd2UgUHJpY2UxDzANBgNVBAsMBkRldk9w
czEcMBoGA1UEAwwTY2EtdWJ1bnR1LTE0MDQtdmJveDCCASIwDQYJKoZIhvcNAQEB
BQADggEPADCCAQoCggEBALz7tCAEhWYYAXwOmihy622P4QFIlD8xH39g4Mh/UuSn
FLyuv51gTD0JkvK5OjpD44lLiWUo71jOKdvBKKtEaVp4ykk8t/e3le3Q6MsTvJpa
LrdqvgpZjKxb5AcWLC0hjCl5+9QFSFqfXwoXqtsWzRRTYnSQnVPqtMmeXZios46h
FiIRmdIkm4GCpUdWTrtruvru/69nKQGuOws98yj+fCXmOZ+t0x1c4S7K+duPnDpR
kc8n+XhxFnkDvYCjJ3kqRqiEdlKo4sbiKSQqINNh4ZwBpfvV0QRRYCebL4fl+vQG
F4RhAwJ+3d+6RdhF+0RgVzzJrfFbhSjqeBc1yR155DsCAwEAAaNQME4wHQYDVR0O
BBYEFOnjHO7mK7YmSYO6uOA+RxPgyVHcMB8GA1UdIwQYMBaAFOnjHO7mK7YmSYO6
uOA+RxPgyVHcMAwGA1UdEwQFMAMBAf8wDQYJKoZIhvcNAQELBQADggEBAHyTTAJs
kGvW2vvEkSFSpzS+3N3Hu0kCcUPrfzb1ljA/Po4XHdyO+hiY8swmuY3TMWfIC0/f
D4YPLinm94v6gefCQERQCLnwjdKBIL0Af0pcRvXQWvTorMxRkU2pRMJntW+EpcxP
O0FX5dW2A9BbBxbDo8kdvOslH6ZAXC6Ls9wUIICaGaFCsXbZeXHvAb0seFDGYSNG
/t2bJKtOasFCRR8DNmmXwfMKimCuOc8knfJaUXprgx1AJmJZFLut+F5YfyxkGVlg
sXgRzL2j5uKIoFKzPeZdLIC+0J/bEq86+0UUnaMLIMHHlsNRqa7rZPNPZTf8yPJD
PIbFGYIonHR99rA=
-----END CERTIFICATE-----
EOF

cat << EOF > /tmp/vault.json
{
  "disable_mlock": true,
  "default_lease_ttl": "24h",
  "max_lease_ttl": "24h",
  "backend": {
    "file":{
      "path":"/tmp"
    }
  },
  "listener": {
    "tcp": {
      "address":"127.0.0.1:8200",
      "tls_cert_file":"/etc/vault.d/vault.crt",
      "tls_key_file":"/etc/vault.d/vault.key"
     }
  }
}
EOF

sudo mv /tmp/vault.* /etc/vault.d
sudo cp /tmp/root.crt /export/appl/pkgs/.vault/
sudo cp /tmp/root.crt /etc/vault.d

cat << EOF > /tmp/vault.service
[Unit]
Description=vault server
Requires=network-online.target
#After=network-online.target consul.service

[Service]
EnvironmentFile=-/etc/service/vault
Environment=GOMAXPROCS=`nproc`
Restart=on-failure
ExecStart=/usr/local/bin/vault server $OPTIONS -config=/etc/vault.d >> /var/log/vault.log 2>&1
ExecStartPost=/bin/bash -c "for key in $KEYS; do /usr/local/sbin/vault unseal $CERT $key; done"

[Install]
WantedBy=multi-user.target
EOF

sudo chown root:root /tmp/vault.service
sudo mv /tmp/vault.service /etc/systemd/system/vault.service
sudo chmod 0644 /etc/systemd/system/vault.service
sudo systemctl daemon-reload
sudo systemctl enable vault.service
sudo systemctl start vault.service

sudo cp /tmp/root.crt /usr/local/share/ca-certificates/
sudo update-ca-certificates

sudo apt-get update
sudo apt-get upgrade -y
sudo apt-get dist-upgrade -y

echo -e "\n[vault environment] setup completed ;) \n";
