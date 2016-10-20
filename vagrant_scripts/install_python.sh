
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
