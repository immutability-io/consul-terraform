#!/usr/bin/env bash

echo -e "\n[vault environment] setup...\n";

sudo mkdir -p /export/appl/pkgs/.vault
sudo mkdir /etc/vault.d

cat << EOF > /tmp/vault.crt
-----BEGIN CERTIFICATE-----
MIIEUDCCAzigAwIBAgIBCjANBgkqhkiG9w0BAQUFADCBkDELMAkGA1UEBhMCVVMx
ETAPBgNVBAgMCE1hcnlsYW5kMRIwEAYDVQQHDAlCYWx0aW1vcmUxGjAYBgNVBAoM
EUltbXV0YWJpbGl0eSwgTExDMSIwIAYDVQQLDBlJbmZyYXN0cnVjdHVyZSBBdXRv
bWF0aW9uMRowGAYDVQQDDBFNeSBEZXZlbG9wbWVudCBDQTAeFw0xNjExMjUyMTA5
MDJaFw0xNzExMjUyMTA5MDJaMHwxGjAYBgNVBAMMESouaW1tdXRhYmlsaXR5Lmlv
MREwDwYDVQQIDAhNYXJ5bGFuZDELMAkGA1UEBhMCVVMxGjAYBgNVBAoMEUltbXV0
YWJpbGl0eSwgTExDMSIwIAYDVQQLDBlJbmZyYXN0cnVjdHVyZSBBdXRvbWF0aW9u
MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA14S/cg+8dgCkjRMwAuxT
TQpdng9kSqscBfOIidIHT/E9OYsud5p3ZRSqhOXflGLa5L3yFif/QCjtQvQ3AvtJ
n7uCGZo1U7W9V5COwqaob2vdRH/b5anf375pfxP6PNL8FvdJxI9X83HSwkpIeGIE
MfpLefSXu+lJ1kNd9VtWkv0S14pUBtu/U8OfDdla5OAL6HOX/5wp4FUvgrAJjMW6
2N/b+eKGhaOQUmpOWZl62VXOthy4Dte6JQc6HP3JNlIvpEufK0028LsBx0VzmrMY
EhAy0oKvm6Izfe7OamlwT35pgMMXeXmb0c26Exv3k2PoLF/3cfkJ7nVxNm15XJii
JQIDAQABo4HHMIHEMAkGA1UdEwQCMAAwHQYDVR0OBBYEFK/WboqQJXfVqXc/X9of
ZG09NnNXMBUGA1UdEQQOMAyHBAAAAACHBH8AAAEwHwYDVR0jBBgwFoAU+iq6s9TG
qh6QADDYVBSbLfaJ7XEwCwYDVR0PBAQDAgWgMB0GA1UdJQQWMBQGCCsGAQUFBwMB
BggrBgEFBQcDAjA0BgNVHR8ELTArMCmgJ6AlhiNodHRwOi8vcGF0aC50by5jcmwv
aGFzaGljb3JwX2NhLmNybDANBgkqhkiG9w0BAQUFAAOCAQEAcguAqpL+WG9nNimg
6s1MXsc0unaeijo74CQ0eEX2vrks/2bgzp7fExb94e7dhJ2gB8eUnhJ91TCIKKl3
K0lm6zjT+YNVTv+mCWIMAPk5LxoSGPBCCyqyyl2p7BPTvc0DdWZfRpMJntjTa0ni
6RtQm4/90AA97gp/rMymCObgqidOEWUQpGjMw2NDUiXbQV30CH0RM97gWYo8/eOd
yGyuVYnpTeCFtCDV7HT8BhpRX3119IET4sfP+NWw+EnfzeLEdQ20HL/nqCLUJROC
eqSU3KYHZO1D1R7csW0kH5LfLZwQuRUcE402QD0LVjTARpaA2Cj49jqLoFfr65TZ
gRn4YA==
-----END CERTIFICATE-----

EOF

cat << EOF > /tmp/vault.key
-----BEGIN PRIVATE KEY-----
MIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQDXhL9yD7x2AKSN
EzAC7FNNCl2eD2RKqxwF84iJ0gdP8T05iy53mndlFKqE5d+UYtrkvfIWJ/9AKO1C
9DcC+0mfu4IZmjVTtb1XkI7Cpqhva91Ef9vlqd/fvml/E/o80vwW90nEj1fzcdLC
Skh4YgQx+kt59Je76UnWQ131W1aS/RLXilQG279Tw58N2Vrk4Avoc5f/nCngVS+C
sAmMxbrY39v54oaFo5BSak5ZmXrZVc62HLgO17olBzoc/ck2Ui+kS58rTTbwuwHH
RXOasxgSEDLSgq+bojN97s5qaXBPfmmAwxd5eZvRzboTG/eTY+gsX/dx+QnudXE2
bXlcmKIlAgMBAAECggEBALXtLxZ/xhzuaflUiyDMkXzlFSXJ5GVLj7pOW6HLk7Sd
9YrPvIfl8od3LIJG8bb2w8R3uxWM6eElKzNrp8xyhzG5PReTnxRsw8pZEsmpmWGE
8iFStTNndL4QpElLed9CUt6oHLM6NYohOUIdJpPIWbY+jNwD5toPEe82quflFG26
ezcwjZcdZeJEr7f/kMv9SrOqVYDd0Y77sT7+HkZZIceaS14GcTmHEgri/0U3WAVV
vW9jKZpjinzCktJaQuouM/S14Om7N0NkvqJ1WbzUhDNQ3oRBaK2FL28qDOfmpqcb
ULyXeRCfHr5aGAvddlBxFQP49XeDT2u/fPkmhp0H0fkCgYEA8BlQnvt44/yRYWhh
2eOnLGvGBeuHmysqdhsgE6WlqntD3KJs5Htak4mDDo/+POMRzhPkXsoQm6gZqw0Z
/aeGj5+S7Kj4t/chJkX1zZ5feXiVidT4889N5HnOzJjHeZLHEeh/WTyH1jcRvhA4
mZL8+fyr4jtmaHoufawmW2h3XuMCgYEA5cqxXprs2iOWl4Iih+uVclbnaIvOD5Qc
oMFr0tMXU6LdDhCRWtoAOjNW1bmtBjUPsK8/jb7+Kclu8cLpaDHvjU9fUK1iH7Yf
mZhpVHCYSULD1IeOirSxY92lP+tmf5vveVHx4pKIb3sPZaWg9AFsQ4Vd8zVdtPCt
axeTJaydgVcCgYBxyG1uilomIUF8Wg1VRw+oe4Kit5XSMUi0I/K1nOC/xB7K5qaY
OOUZ2icjtZWUoT+E2+R0D2qDecyARXs1vDiGw+bLBOCpvhIVoz3zrcQtOroTUbyR
PoL5bchVKWoO8UIp+HaxgYAWQo7D9cf87623gsiqM+A6TvzNTdH3q7A2ZQKBgC/O
BSxLSq7u7GtElW51YjfRQH8NZqbzBymiU44egCHUJezBIZwm8hkpiQ0ZfZdm/oah
TrVsYG/NChmdlPUqPk3Fj2y3RUyXlOddP7xjWCsViqvyL4NHqAfAmpo7nK07gYxZ
sdqS5XNbxI4+8McSbLV3T15DYeU8lLdMxj32NSYtAoGBAKTNfRvcEXKXlHHGcEg5
9fRXkbALgMVUQTEppdS7WZlV77diI4K4YSvB7zHcDmi3NnAvBVXlGt9sJ1F5eolT
+zrGbqGnZFbmw3Ag+PE7ArAItQMZoIXQrl9wkgqDsbQW5gH20mW+MG7ILxRXCQYo
Y+R48K6teDwOx2RTpClr6AcN
-----END PRIVATE KEY-----
EOF

cat << EOF > /tmp/root.crt
-----BEGIN CERTIFICATE-----
MIID9TCCAt2gAwIBAgIJAOTk5hBuZo8fMA0GCSqGSIb3DQEBCwUAMIGQMQswCQYD
VQQGEwJVUzERMA8GA1UECAwITWFyeWxhbmQxEjAQBgNVBAcMCUJhbHRpbW9yZTEa
MBgGA1UECgwRSW1tdXRhYmlsaXR5LCBMTEMxIjAgBgNVBAsMGUluZnJhc3RydWN0
dXJlIEF1dG9tYXRpb24xGjAYBgNVBAMMEU15IERldmVsb3BtZW50IENBMB4XDTE2
MTEyNTIxMDkwMloXDTI2MTEyMzIxMDkwMlowgZAxCzAJBgNVBAYTAlVTMREwDwYD
VQQIDAhNYXJ5bGFuZDESMBAGA1UEBwwJQmFsdGltb3JlMRowGAYDVQQKDBFJbW11
dGFiaWxpdHksIExMQzEiMCAGA1UECwwZSW5mcmFzdHJ1Y3R1cmUgQXV0b21hdGlv
bjEaMBgGA1UEAwwRTXkgRGV2ZWxvcG1lbnQgQ0EwggEiMA0GCSqGSIb3DQEBAQUA
A4IBDwAwggEKAoIBAQDxjcKdUH9JMyT7RpsYVA+jO9CjyMF3SfFOXlqQRVHI6UjH
jfQM1ApNcYQ7b+gikWht4/FK8Gef2rqDa10J9SgYBbpsQ3CPoGrYz9GND0mMCwYQ
8sUOe5GkccNcmGscxGlFhhNrNkcnKqTwaW03CZTOR+4j89GbSEMyeQDtlgFUV0al
EevzJQxhCFz1Mhr5btowUH4+Y3yhaF91/mIfbhGtA9K1S9XNP8ReBMkkdft9K+T8
ZsvRj9YubJDVHmh+6EsIZ7pGS4DsnXAKgCGDRfvKTQif4FclThTeSBhgFXgrdYym
P7s/pc2aeEMqiMGR9xpgZzdtfg+B6FjQJW+4pGwvAgMBAAGjUDBOMB0GA1UdDgQW
BBT6Krqz1MaqHpAAMNhUFJst9ontcTAfBgNVHSMEGDAWgBT6Krqz1MaqHpAAMNhU
FJst9ontcTAMBgNVHRMEBTADAQH/MA0GCSqGSIb3DQEBCwUAA4IBAQDn6pHELKhv
vtxKhSpvx63H4Jozq38bnZ/06d+iV7mbTsODmUZ09yJqRDolLBbkZFCivmLPMMH+
dawA/UWDhpE+2rCuMLkkP5XjhbuaG8IXo9LmZ6EcPlGbBldqyK9H6DAyPZWsZvje
Ij1ZM8e+xtx76mZn3Z2FYEVf/nH/aIp3Bz39OZ1H5i8f82OfXuoSPtaYrbYRcORt
b1grAuiWEe9RvKR2KW38OXk9PsYgDWO1zgxzTrfccdtPJoExbdUDk0DDfU/PO9vU
CmssYX6IwRksGw0dmkKJiH6LBJS+5cRPSRaFJlUB1cV9rNfOS46nCUAq7usoI+LX
/cX8JiQDCbh0
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
After=network-online.target

[Service]
EnvironmentFile=-/etc/sysconfig/vault
Environment=GOMAXPROCS=`nproc`
Restart=on-failure
ExecStart=/usr/local/bin/vault server $OPTIONS -config=/etc/vault.d >> /var/log/vault.log 2>&1
ExecReload=/bin/kill -HUP $MAINPID
KillSignal=SIGTERM

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
