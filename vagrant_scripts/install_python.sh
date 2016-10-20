
sudo apt-get update
sudo apt-get upgrade
sudo apt-get -y install build-essential checkinstall ksh build-dep git
sudo apt-get -y install libreadline-gplv2-dev libncursesw5-dev libssl-dev libsqlite3-dev tk-dev libgdbm-dev libc6-dev libbz2-dev
cd /usr/src
sudo wget https://www.python.org/ftp/python/2.7.12/Python-2.7.12.tgz >/dev/null 2>&1
sudo tar xzf Python-2.7.12.tgz
cd Python-2.7.12
sudo ./configure
sudo make install
sudo wget https://bootstrap.pypa.io/get-pip.py  >/dev/null 2>&1
python get-pip.py
sudo pip install --upgrade pip
sudo pip install --upgrade virtualenv
sudo pip install git+https://github.com/cypherhat/hvac
sudo add-apt-repository -y ppa:ubuntu-lxc/lxd-stable
sudo apt-get -y update
sudo apt-get -y install golang
sudo wget -O /usr/bin/jq https://github.com/stedolan/jq/releases/download/jq-1.5/jq-linux64
sudo wget -O ~/vault.zip https://releases.hashicorp.com/vault/0.6.2/vault_0.6.2_linux_amd64.zip
sudo unzip ~/vault.zip
sudo mv ~/vault /usr/local/bin/vault
sudo rm /usr/local/bin/terraform*
sudo wget -O ~/terraform.zip https://releases.hashicorp.com/terraform/0.7.7/terraform_0.7.7_linux_amd64.zip
sudo unzip ~/terraform.zip
sudo mv ~/terraform /usr/local/bin/terraform
sudo wget -O ~/consul.zip https://releases.hashicorp.com/consul/0.7.0/consul_0.7.0_linux_amd64.zip
sudo unzip ~/consul.zip
sudo mv ~/consul /usr/local/bin/consul
