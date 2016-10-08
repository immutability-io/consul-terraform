## Getting started

This is a Vagrant box for developing code that leverages the Vault API. Since we use TLS authentication, there is a Python script to configure the Vault for that. Python 2.7.12 is installed. I had to fork the *official* [Python Vault API] (https://github.com/ianunruh/hvac) because it didn't support the `sys/mounts/<mount point>/tune` API. So, my fork of this API is installed. When/if my pull request is accepted, we can use the *official* version.

When you provision the Vagrant box (`vagrant up`) a version of Vault will be installed and configured for TLS. It uses the file system for persistence.

### 1-time Configuration

After provisioning, `vagrant ssh` to connect to your Vagrant box. You need to run a script to configure Vault for TLS authentication. You should only run this once after provisioning:

```
$ cd /vagrant/vagrant_scripts
$ sudo python configure_vault.py
```

The output of this script will tell you your vault root token, your TLS keypair, and the policy associated with your TLS keypair. The script also authenticates with this keypair and renews the token to demonstrate the mechanism.

```
print_banner('Testing application TLS authentication')
test_tls_auth = hvac.Client(url=VAULT_ADDR, token=VAULT_TOKEN, cert=(crt_file, key_file), verify=VAULT_CACERT)
result = test_tls_auth.auth_tls()
print json.dumps(result, indent=4, sort_keys=True)

client_token = result["auth"]["client_token"]
print 'Your token: '+client_token
print_banner('Testing token renewal')
renew = test_tls_auth.renew_token(token=None)
renewed_client_token = renew["auth"]["client_token"]
print 'Your renewed token: '+renewed_client_token

```

### Other stuff

Your application's TLS token has a common name named after the `uname -n` of the Vagrant box.

If you want to reinitialize the vault without re-provisioning, you can run the `kill_vault.sh` script. Then you will have to start the vault again `start_vault.sh` and re-configure.
