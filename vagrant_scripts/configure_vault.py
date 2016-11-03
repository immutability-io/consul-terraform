
import hvac
import argparse
import os
import json
import datetime
import time
import requests
from requests.packages.urllib3.exceptions import InsecureRequestWarning

requests.packages.urllib3.disable_warnings(InsecureRequestWarning)

def print_banner(message):
    print '*-'+'-'*len(message)+'-*'
    print '* '+message+' *'
    print '*-'+'-'*len(message)+'-*'

try:
    myhost = os.uname()[1]
    policy_directory = '/tmp'
    policy_name = myhost+'-read'
    policy_file = policy_name+'.hcl'
    common_name = 'application.'+myhost
    crt_file = '/export/appl/pkgs/.vault/'+common_name+'.crt'
    key_file = '/export/appl/pkgs/.vault/'+common_name+'.key'
    dot_profile = '/vagrant/config/dot_files/profile'

    VAULT_TOKEN = ''
    VAULT_ADDR = 'https://127.0.0.1:8200'
    VAULT_CACERT = ''

    # Create the vault client using TLS
    bootstrap_client = hvac.Client(url=VAULT_ADDR, token=VAULT_TOKEN, cert=None, verify=VAULT_CACERT)
    if bootstrap_client.is_initialized != True:
        vault_keys = bootstrap_client.initialize()
        print_banner("Unseal keys")
        for unseal_key in vault_keys["keys"]:
            bootstrap_client.unseal(unseal_key)
            print unseal_key
        print_banner("Root token")
        root_token = vault_keys["root_token"]
        print root_token
        with open(dot_profile, 'a') as outfile:
            outfile.write("export VAULT_ADDR="+VAULT_ADDR+"\n")
            outfile.write("export VAULT_TOKEN="+root_token+"\n")
    else:
        print "Vault is initialized."

    #Mount the pki backend
    client = hvac.Client(url=VAULT_ADDR, token=root_token, cert=None, verify=VAULT_CACERT)
    print "* Enable PKI backend"
    client.enable_secret_backend(backend_type='pki')
    print "* Tune PKI backend"
    client.tune_secret_backend(backend_type='pki', max_lease_ttl='86400h')
    print "* Enable Cert auth"
    client.enable_auth_backend(backend_type='cert')
    print_banner("Root certificate")
    root_certificate = client.write(path='pki/root/generate/internal', common_name=myhost,ttl='86400m')
    print root_certificate["data"]["certificate"]
    print_banner("Issuing certificate")
    print root_certificate["data"]["issuing_ca"]
    print "* Write CRLs"
    client.write(path='pki/config/urls', issuing_certificates='https://127.0.0.1:8200/v1/pki/ca', crl_distribution_points='https://127.0.0.1:8200/v1/pki/crl')
    print "* Setup role for issuing certs"
    client.write(path='pki/roles/'+myhost, allowed_domains=myhost, allow_subdomains=True, max_ttl='8760h')
    print_banner("Setup host policy: "+policy_name)
    with open(policy_directory+'/'+policy_file, 'r') as rules:
        rule = rules.read()
    client.set_policy(policy_name, rule)
    print rule

    print_banner("Issue application TLS token for: "+common_name)
    result = client.write('pki/issue/'+myhost, common_name=common_name)

    data = result['data']

    print_banner("This is your certificate")
    certificate = data['certificate']
    private_key = data['private_key']
    print certificate
    print_banner("This is your private key")
    print private_key
    print_banner("* Write certificate to "+crt_file)
    with open(crt_file, 'w') as outfile:
        outfile.write(certificate)
    print_banner("* Write private key to "+key_file)
    with open(key_file, 'w') as outfile:
        outfile.write(private_key)

    #Associate the cert with the mf.sec read policy

    auth_path = 'auth/cert/certs/'+common_name
    result = client.write(auth_path, display_name=common_name, policies=policy_name, certificate=certificate, ttl=86400)
    print ('* Attached policy to certificate: '+policy_name+'<--->'+common_name)

    print_banner('Testing application TLS authentication')
    test_tls_auth = hvac.Client(url=VAULT_ADDR, token=VAULT_TOKEN, cert=(crt_file, key_file), verify=VAULT_CACERT)
    result = test_tls_auth.auth_tls()
    print json.dumps(result, indent=4, sort_keys=True)

    print_banner('Testing application TLS authentication')
    client_token = result["auth"]["client_token"]
    print 'Your token: '+client_token
    print_banner('Testing token renewal')
    renew = test_tls_auth.renew_token(token=None)
    renewed_client_token = renew["auth"]["client_token"]
    print 'Your renewed token: '+renewed_client_token
except:
    raise
