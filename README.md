## Getting Started

First, set your AWS secret keys into your environment:

```
export TF_VAR_aws_access_key=""
export TF_VAR_aws_secret_key=""

```

Then set your keys in your .tfvars file:

```
ami = ""
key_name = ""
key_path = ""
associate_public_ip_address = ...
region = ""
subnet_id = ""
vpc_id = ""

```

The `consul-cluster.tf` is an example Terraform template that will build a Consul cluster. You have to provide an AWS keypair. The first step is to download the consul module:

```
$ terraform get
```

Then you need to run a terraform plan to see what the effect of the template will be. You need to supply the path and name of your keypair:

```
$ terraform plan -var 'key_path=/Users/tssbi08/develop/consul.pem' -var 'key_name=consul'
```

Finally, you apply the template:

```
$ terraform apply -var 'key_path=/Users/tssbi08/develop/consul.pem' -var 'key_name=consul'
```

This should build a 3-node consul cluster.
