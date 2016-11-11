
logger "Install keybase"

curl -O https://prerelease.keybase.io/keybase_amd64.deb
dpkg -i keybase_amd64.deb
apt-get install -f -y
rm keybase_amd64.deb

logger "Keybase installed"
