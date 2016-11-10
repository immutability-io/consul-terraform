## Getting Started

This project is a development exercise in building a HashiCorp [Consul](https://consul.io) cluster in AWS using HashiCorp [Terraform] (https://terraform.io), [Packer](https://www.packer.io) and [Vault](https://vaultproject.io). I have a Slack channel for this repository. Please comment on [this issue](https://github.com/Immutability-io/consul-terraform/issues/7) to get an invite to the channel.

The first thing we do is bring up a HashiCorp [Vagrant](https://www.vagrantup.com/) box (`vagrant up`). This will install a few things:

* Python 2.7.12
* Packer 0.10.1
* Vault 0.6.2
* Consul 0.7.0
* golang 1.6+
* Terraform 0.7.9
* git

### Vault in the Vagrant

Vault will be installed and started during the vagrant up process. It will *not* be initialized yet. You have to ssh into the Vagrant box (`vagrant ssh`) to do this. To setup the vault and provide your domain(s) as an argument.

```
$ source /vagrant/vagrant_scripts/setup_vault.sh example.com,example.net
```

This does a few things.  It will configure the vault, output a set of vault_secrets, and configure the vault as a Certificate Authority (CA).  You will find the cert and key for your domain in the folder where you ran the command above.


If you would like to play a bit more you can test your CA by issuing a certificate, but you do not need to do this:

```
vault write -format=json vault_intermediate/issue/web_server common_name="test.example.com"  ip_sans="172.17.0.2" ttl=720h > test.example.com.json
cat test.example.com.json | jq -r .data.certificate | cat > test.example.com.crt
cat test.example.com.json | jq -r .data.issuing_ca | cat > issuing_ca.crt
cat test.example.com.json | jq -r .data.private_key | cat > test.example.com.key
```

You can take a look at the Python script and the `use_vault_as_ca.sh` script to see what is going on here. (There is extra stuff going on in the Python script to create some TLS authentication tokens. These are *not* used in this project, but it was something I needed to try.)

### Building the base AMI

*Note: This entire exercise assumes that you are using Ubuntu 14.04 or greater.*

We will user Packer to create a base AMI for the Consul cluster as well as the Consul services. This AMI will be used for Consul clients as well. This Packer template will use the following environment variables.  Later on the terraform process will use some as well.  To track these in a file that will not be checked in by git do the following:

```
cat << EOF > /vagrant/vagrant_scripts/exports.source
#!/usr/bin/env bash

export AWS_ACCESS_KEY_ID="---insert your AWS key---"
export AWS_SECRET_ACCESS_KEY="---insert your AWS secret key---"
export DEFAULT_REGION_NAME="us-east-1"
export DEFAULT_VPC_ID="---insert your AWS VPC ID---"
export DEFAULT_AMI_ID="ami-40d28157"
export DEFAULT_SUBNET_ID="---insert your AWS subnet---"
export DEFAULT_INSTANCE_TYPE="t2.micro"
export DEFAULT_AMI_NAME="my-consul-ami"
export PACKER_LOG=1
export PACKER_LOG_PATH=./packer.log
export TF_LOG_PATH="/tmp/terraform.log"
export TF_LOG="DEBUG"
export DNS_LISTEN_ADDR="0.0.0.0"
export DEFAULT_AMI_NAME="consul-server"
#export DNS_LISTEN_ADDR="127.0.0.1"
#export DEFAULT_AMI_NAME="consul-agent"

export TF_VAR_unique_prefix="`python -c "import uuid;print uuid.uuid1()"`"
export TF_VAR_slack_key="---get it from the slack channel---"
export TF_VAR_ami="---insert your packer AMI id here---"
export TF_VAR_key_name="---insert your AWS Keypair name---"
export TF_VAR_service_config="./config/go-rest.json"
export TF_VAR_datacenter="my-data-center"
export TF_VAR_private_key="---location of AWS Keypair private key---"
export TF_VAR_root_certificate="./ssl/vault_root.cer"
export TF_VAR_consul_certificate="./ssl/consul.cer"
export TF_VAR_consul_key="./ssl/consul.key"
export TF_VAR_domain_name="example.com"
#Do what you want... you can use the same cert for all, but you shouldn't.
export TF_VAR_vault_root_certificate="~/vault_root.crt"
export TF_VAR_vault_certificate="~/vault.cer"
export TF_VAR_vault_key="~/vault.key"
export TF_VAR_common_name="*.ec2.internal"
export TF_VAR_alt_names="test1.example.com"
export TF_VAR_ip_sans="127.0.0.1"
export TF_VAR_associate_public_ip_address="true"
export TF_VAR_region="\$DEFAULT_REGION_NAME"
export TF_VAR_subnet_id="\$DEFAULT_SUBNET_ID"
export TF_VAR_vpc_id="\$DEFAULT_VPC_ID"
export TF_VAR_vpc_cidr="---insert your AWS route53 zone id---"
export TF_VAR_tagFinance="CostCenter:Project"
export TF_VAR_tagOwnerEmail="---Your email---"
export TF_VAR_gossip_encryption_key="--- Use command :'consul keygen' ---"
export TF_VAR_password_file="./config/.htpasswd"
export TF_VAR_service_count="3"
export TF_VAR_vault_token="\$VAULT_TOKEN"
export TF_VAR_aws_route53_zone_id="---insert your AWS route53 zone id---"
EOF

```

Now you can make changes to `/vagrant/vagrant_scripts/exports.source` for your environment and then source the file to your session.  Anytime you need to update a variable do the same.  Note, there are a lot of things you need to fill in here so maybe we shall make this a bit easier later.

```
source /vagrant/vagrant_scripts/exports.source
```

Once the environment variables are set, we run Packer. If you notice, there are settings to enable Packer logging. This is often useful in environments with proxies that prevent Internet egress. It is also interesting in that you see the AWS APIs that are invoked by Packer during the AMI build.

First we make sure the Packer template is valid:

```
$ cd /vagrant/packer
$ packer validate consul.json
```

Assuming that there were no errors, we initiate the build:

```
$ packer build consul.json
```

After a successful build, we will have a new AMI ID. Take note of this because it will be used in the Terraform phase.  You should update the TF VAR AMI ID in your exports.source and re-source it as well.

```
==> Builds finished. The artifacts of successful builds are:
--> amazon-ebs: AMIs were created:

us-east-1: ami-6eeab979
```


### Terraforming the Consul Cluster

If infrastructure is a cat, then Terraform is the Swiss Army knife that lets you skin it in a variety of ways. *NOTE: Don't skin any real cats - they have claws!*

This project demonstrates the use of Terraform modules to encapsulate certain operations for *maximum* re-use.

### A note on Terraform modules

Each of my Terraform modules are composed of 3 main components:

Component | File | Purpose
--- | --- | ---
*Main* | `main.tf` | **Provisions the core capability of the component.**
*Inputs* | `variables.tf` | **Declares the inputs to this module.**
*Outputs* | `outputs.tf` | **Declares the outputs to this module.**

In addition, modules typically contain scripts and configuration files in directories named (suprisingly enough):

`scripts` and `config`.

The modules in this project are:

#### consul-node: A server node in a consul cluster.

The consul-node module creates an EC2 instance (based on the AMI we built above) and pushes various configurations to it:

* IP Tables configuration to allow the Consul gossip traffic on ports 8300, 8301, 8302, 8400
* A Systemd configuration to load consul as soon as networking starts.
* An nginx.conf to proxy 443 (HTTPS) to the Consul UI on 8500. Nginx is configured for basic authentication using an .htpasswd file. See [here](https://www.digitalocean.com/community/tutorials/how-to-set-up-password-authentication-with-nginx-on-ubuntu-14-04). htpasswd is installed in the vagrant box, so you can use it to generate your own .htpasswd file.

This module also creates a security group that allows gossip traffic on the above ports.

#### consul-cluster: A consul cluster composed of consul-node(s).

The consul-cluster module creates cluster of EC2 instances (based on the consul-node module) and pushes various configurations to it:

* The consul configuration uses the `retry_join` to ensure high availability. This parameter contains the private IP addresses of each node in the cluster. We use a [Terraform Template](https://www.terraform.io/docs/providers/template/) and a [Terraform Null Resource](https://www.terraform.io/docs/provisioners/null_resource.html) to build this configuration.

#### consul-service: A set of REST services that register with Consul

The consul-service creates EC2 instances (also based on the AMI we built above) that run a REST service that registers with Consul. This can be any *single file* executable. For demo sake, we use a [simple golang program](https://github.com/Immutability-io/go-rest) that I wrote that has 2 health check endpoints:

* /health: Always healthy.
* /unhealthy: Unhealthy 30% of the time.

The service configuration uses the `/unhealthy` endpoint for demo purposes. After deployment, you can test the Consul DNS interface as follows:

Using the outputs of your Terraform apply:

```
Outputs:

cluster_private_server_ips = [
    172.31.61.169,
    172.31.52.240,
    172.31.52.123
]
cluster_public_server_ips = [
    52.91.1.1,
    54.175.1.1,
    52.87.1.1
]
service_private_server_ips = [
    172.31.48.16,
    172.31.59.232,
    172.31.63.141
]
service_public_server_ips = [
    54.175.1.1,
    52.23.1.1,
    54.159.1.1
]
```

SSH to one of the service instances:

```
$ ssh -i keyname.pem ubuntu@54.175.1.1
```

Now, use `dig` to discover the port for your service (which you named `go-rest`.) Consul services are named using the following method:

```
<service-name>.service.<datacenter>.consul
```

So, the following *shortened* dig query will return the port:

```
ubuntu@ip-172-31-59-232:~$ dig +short go-rest.service.my-data-center.consul. SRV
1 1 8080 ip-172-31-59-232.node.my-data-center.consul.
1 1 8080 ip-172-31-48-16.node.my-data-center.consul.
```

Since our health checks are *randomly* successful 70% of the time, we can expect that we get the local instance of the service *most* of the time. If we execute `curl -q http://go-rest.service.my-data-center.consul:8080/hello | jq .` repeatedly, we see that we find the closest service most of the time:

```
ubuntu@ip-172-31-59-232:~$ curl -s http://go-rest.service.my-data-center.consul:8080/hello | jq .
{
  "IPv4": "172.31.59.232",
  "Host": "ip-172-31-59-232"
}
```

Eventually, our local service tests unhealthy and we find a remote instance:

```
ubuntu@ip-172-31-59-232:~$ curl -s http://go-rest.service.my-data-center.consul:8080/hello | jq .
{
  "IPv4": "172.31.63.141",
  "Host": "ip-172-31-63-141"
}

```

Digging through SRV records to find the port associated with your service isn't the most awesome thing in the world, but you can throw care into the wind and do this:

```
ubuntu@ip-172-31-59-232:~$ curl http://go-rest.service.my-data-center.consul:`dig +short  go-rest.service.my-data-center.consul. SRV | awk '{print $3}' | head -1`/hello
{
"Host": "ip-172-31-59-232",
"IPv4": "172.31.59.232"
}
```

#### vault-pki: A rudimentary integration with Vault for issuing certificates.

The vault-pki module will write a certificate, CA certificate and private key to the local file system for use in setting up the Consul cluster.

### NOTE ON VAULT MODULE

This module is a *hack*. It is just a place holder, and a weak one at that, until the vault terraform provider has been... provided... [Rumor is that this will be in Terraform 0.8](https://twitter.com/mitchellh/status/794247604372525056)

In order to use the vault module, you need to configure vault as a CA. The follow script (`use_vault_as_ca.sh`) will do this:

```
vault mount -path=vault_root -description="Vault Root CA" -max-lease-ttl=87600h pki
vault write -format=json vault_root/root/generate/internal common_name="Vault Root CA" ttl=87600h key_bits=4096 exclude_cn_from_sans=true | jq -r .data.issuing_ca | cat > root.crt
vault write vault_root/config/urls issuing_certificates="https://127.0.0.1:8200/v1/vault_root"
vault mount -path=vault_intermediate -description="Vault Intermediate CA" -max-lease-ttl=26280h pki
vault write -format=json vault_intermediate/intermediate/generate/internal common_name="Vault Intermediate CA" ttl=26280h key_bits=4096 exclude_cn_from_sans=true | jq -r .data.csr | cat > vault_intermediate.csr
vault write -format=json vault_root/root/sign-intermediate csr=@vault_intermediate.csr common_name="Vault Intermediate CA" ttl=8760h | jq -r .data.certificate | cat > vault_intermediate.crt
vault write vault_intermediate/intermediate/set-signed certificate=@vault_intermediate.crt
vault write vault_intermediate/config/urls issuing_certificates="https://127.0.0.1:8200/v1/vault_intermediate/ca"  crl_distribution_points="https://127.0.0.1:8200/v1/vault_intermediate/crl"
vault write vault_intermediate/roles/web_server key_bits=2048 max_ttl=8760h allowed_domains="example.com,example.net" allow_bare_domains=true allow_subdomains=true allow_ip_sans=true

```

#### fabio: A load balancer for Consul

As discussed above, digging through SRV records for the port of your service is a bit... awkward... A better solution is to use [Fabio](https://github.com/eBay/fabio) which is a low-touch load balancer for Consul services. When you use Fabio, you alway use the port of the Fabio server (9999). The only point of integration needed to enable Fabio is to add a tag `urlprefix-` to your Consul service config:

```
"tags": ["go-rest", "urlprefix-/hello"],

```

There are a variety of ways to use `urlprefix-`. Assuming that the IP of the Fabio server is `172.31.59.176`, the above `urlprefix-` confuration will allow you to do the following:

```
$ curl 172.31.59.176:9999/hello
{
"Host": "ip-172-31-59-32",
"IPv4": "172.31.59.32"
}
```

Fabio has a UI, like consul, and this Terraform module puts nginx in front of it for authentication and HTTPS.

### TFVARS

So, there are a lot of inputs to the terraform template. These are things that vary based on your own context. I will paste *some* of these here to help you get started.

One variable, `slack_key`, requires that you contact me directly. I don't want people sending incoming messages to my Slack webhook.

```
slack_key = "<Contact me please>"
ami = "<the AMI from your Packer build>"
key_name = "<AWS Keypair name>"
service_config = "./config/go-rest.json"
datacenter = "my-data-center"
private_key = "<location of AWS Keypair private key>"
root_certificate = "./ssl/vault_root.cer"
consul_certificate = "./ssl/consul.cer"
consul_key = "./ssl/consul.key"
common_name = "consul.example.com"
ip_sans = "127.0.0.1"
associate_public_ip_address = "true"
region = "us-east-1"
subnet_id = "<AWS subnet ID>"
vpc_id = "<AWS VPC ID>"
tagFinance = "CostCenter:Project"
tagOwnerEmail = "<Your email>"
gossip_encryption_key = "<Use `consul keygen`>"
password_file = "./config/.htpasswd"
service_count = "3"
vault_token = "<harvested from above>"

```
