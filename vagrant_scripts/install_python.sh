#!/usr/bin/env bash

echo -e "\n[python] installing...\n";

sudo apt-get -qq update
sudo apt-get -qq  upgrade
sudo apt-get -y -qq install build-essential checkinstall ksh git unzip
#for some reason this just won't be quiet. Maybe a vagrant thing.
sudo apt-get -y -qq install libreadline-gplv2-dev libncursesw5-dev libssl-dev libsqlite3-dev tk-dev libgdbm-dev libc6-dev libbz2-dev apache2-utils
cd /usr/src
sudo wget --progress=bar:force https://www.python.org/ftp/python/2.7.12/Python-2.7.12.tgz

echo -e "\n[python] untar...\n";

sudo tar xzf Python-2.7.12.tgz
cd Python-2.7.12

echo -e "\n[python] configure...\n";

sudo ./configure > /tmp/python-configure.log 2>&1

echo -e "\n[python] compiling...\n";

sudo make --silent install
sudo wget --progress=bar:force https://bootstrap.pypa.io/get-pip.py

echo -e "\n[python] get-pip bootstrap...\n";

python get-pip.py > /tmp/get-pip.log 2>&1

echo -e "\n[python] pip and other stuff...\n";

sudo pip install --quiet --upgrade pip
sudo pip install --quiet --upgrade virtualenv
sudo pip install --quiet git+https://github.com/cypherhat/hvac
sudo add-apt-repository -y ppa:ubuntu-lxc/lxd-stable
sudo apt-get -y -qq update
sudo apt-get -y -qq install golang
sudo wget --progress=bar:force -O /usr/bin/jq https://github.com/stedolan/jq/releases/download/jq-1.5/jq-linux64
sudo chmod +x /usr/bin/jq
echo -e "\n[python] install completed ;) \n";