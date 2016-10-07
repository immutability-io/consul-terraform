
logger() {
  DT=$(date '+%Y/%m/%d %H:%M:%S')
  echo "$DT go.sh: $1"
}

logger "Executing"

export GOPATH=/ops/work
export PATH=$PATH:/usr/local/go/bin:$GOPATH/bin

logger "Build and install consul-backinator"
apt-get -y update
apt-get -y upgrade
apt-get -y install git
apt-get -y install golang-go
go get -u github.com/myENA/consul-backinator

mv $GOPATH/bin/consul-backinator /usr/local/bin
logger "Completed"
