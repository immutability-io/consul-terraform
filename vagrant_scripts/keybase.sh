
logger "Install keybase"

sudo curl -O https://prerelease.keybase.io/keybase_amd64.deb
sudo dpkg -i keybase_amd64.deb
sudo apt-get install -f -y
sudo rm keybase_amd64.deb

logger "Keybase installed"
