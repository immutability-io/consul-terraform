#!/usr/bin/env bash

echo -e "\n[hashi tools] updating...\n";

sudo wget  --progress=bar:force -O ./vault.zip https://releases.hashicorp.com/vault/0.6.2/vault_0.6.2_linux_amd64.zip
sudo unzip ./vault.zip
sudo mv ./vault /usr/local/bin/vault
sudo rm /usr/local/bin/terraform*
sudo wget  --progress=bar:force -O ./terraform.zip https://releases.hashicorp.com/terraform/0.7.7/terraform_0.7.7_linux_amd64.zip
sudo unzip ./terraform.zip
sudo mv ./terraform /usr/local/bin/terraform
sudo wget  --progress=bar:force -O ./consul.zip https://releases.hashicorp.com/consul/0.7.0/consul_0.7.0_linux_amd64.zip
sudo unzip ./consul.zip
sudo mv ./consul /usr/local/bin/consul
sudo wget  --progress=bar:force -O ./packer.zip https://releases.hashicorp.com/packer/0.11.0/packer_0.11.0_linux_amd64.zip
sudo unzip ./packer.zip
sudo mv ./packer /usr/local/bin/packer

echo -e "\n[hashi tools] update completed ;) \n";
