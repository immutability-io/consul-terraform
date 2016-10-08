sudo kill $(ps aux | grep 'sudo nohup vault server' | awk '{print $2}')
sudo rm -fr /tmp/core
sudo rm -fr /tmp/sys
