
logger "Install various dependencies"

sudo apt-get update
sudo apt -y install python-pip
sudo pip install --quiet --upgrade pip
sudo pip install --quiet --upgrade virtualenv
sudo pip install --quiet git+https://github.com/cypherhat/hvac
sudo add-apt-repository -y ppa:ubuntu-lxc/lxd-stable
sudo apt-get -y update
sudo apt-get -y install golang
sudo apt-get -y install ksh git unzip awscli
sudo apt-get -y install httpie
sudo wget --progress=bar:force -O /usr/bin/jq https://github.com/stedolan/jq/releases/download/jq-1.5/jq-linux64
sudo chmod +x /usr/bin/jq
sudo wget --progress=bar:force -O ./keybase_amd64.deb https://prerelease.keybase.io/keybase_amd64.deb
sudo dpkg -i ./keybase_amd64.deb
sudo apt-get -f -y install
sudo rm ./keybase_amd64.deb
sudo apt-get -y upgrade
logger "various dependencies installed"
