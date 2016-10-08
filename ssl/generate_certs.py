
import hvac
import argparse
import os
import json
import datetime
import time
import requests
from requests.packages.urllib3.exceptions import InsecureRequestWarning

requests.packages.urllib3.disable_warnings(InsecureRequestWarning)

try:

    myhost = os.uname()[1]
    VAULT_TOKEN = os.environ['VAULT_TOKEN']
    VAULT_ADDR = os.environ['VAULT_ADDR']
    VAULT_CACERT = os.environ['VAULT_CACERT']
    parser = argparse.ArgumentParser(description='Generate Keypair')
    parser.add_argument('common_name',
        help='Common name for certificate' )
    parser.add_argument('path',
        help='Path for certificate files' )
    args = parser.parse_args()

    # Create the vault client using TLS
    client = hvac.Client(url=VAULT_ADDR, token=VAULT_TOKEN, cert=None, verify=VAULT_CACERT)

    # Issue a cert
    result = client.write('pki/issue/'+myhost, common_name=args.common_name)
    print ('Issued certificate: '+args.common_name)

    data = result['data']

    certificate_file = args.path + "/" + args.common_name + ".crt"
    certificate = data['certificate']
    with open(certificate_file, 'w') as outfile:
        outfile.write(certificate)
    private_key_file = args.path + "/" + args.common_name + ".key"
    private_key = data['private_key']
    with open(private_key_file, 'w') as outfile:
        outfile.write(private_key)
    issuer_file = args.path + "/" + "issuer.crt"
    issuer = data['issuer']
    with open(issuer_file, 'w') as outfile:
        outfile.write(issuer)

except:
    raise
