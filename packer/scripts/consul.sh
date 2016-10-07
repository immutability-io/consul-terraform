#!/bin/bash
set -e

logger() {
  DT=$(date '+%Y/%m/%d %H:%M:%S')
  echo "$DT consul.sh: $1"
}

logger "Executing"

cd /tmp


CONSUL_VERSION=0.7.0
CONSUL_TEMPLATE_VERSION=0.16.0
CONSUL_REPLICATE_VERSION=0.2.0
ENVCONSUL_VERSION=0.6.1
CONSUL_DOWNLOAD=https://releases.hashicorp.com/consul/${CONSUL_VERSION}/consul_${CONSUL_VERSION}_linux_amd64.zip
CONSUL_TEMPLATE_DOWNLOAD=https://releases.hashicorp.com/consul-template/${CONSUL_TEMPLATE_VERSION}/consul-template_${CONSUL_TEMPLATE_VERSION}_linux_amd64.zip
CONSUL_REPLICATE_DOWNLOAD=https://releases.hashicorp.com/consul-replicate/${CONSUL_REPLICATE_VERSION}/consul-replicate_${CONSUL_REPLICATE_VERSION}_linux_amd64.zip
ENVCONSUL_DOWNLOAD=https://releases.hashicorp.com/envconsul/${ENVCONSUL_VERSION}/envconsul_${ENVCONSUL_VERSION}_linux_amd64.zip
CONSUL_WEBUI=https://releases.hashicorp.com/consul/${CONSUL_VERSION}/consul_${CONSUL_VERSION}_web_ui.zip
CONSUL_DIR=/opt/consul
CONSUL_BACKINATOR_DOWNLOAD=https://s3.amazonaws.com/immutability.io/distro/consul-backinator.zip

logger "Fetching Consul"
logger $CONSUL_DOWNLOAD
curl $CONSUL_DOWNLOAD > consul.zip

logger "Installing Consul"
unzip consul.zip -d /usr/local/bin
chmod 0755 /usr/local/bin/consul
chown root:root /usr/local/bin/consul

logger "Fetching Consul Backinator"
logger $CONSUL_BACKINATOR_DOWNLOAD
curl $CONSUL_BACKINATOR_DOWNLOAD > consul-backinator.zip

logger "Installing Consul Backinator"
unzip consul-backinator.zip -d /usr/local/bin
chmod 0755 /usr/local/bin/consul-backinator
chown root:root /usr/local/bin/consul-backinator

logger "Fetching Consul Template"
logger $CONSUL_TEMPLATE_DOWNLOAD
curl -L $CONSUL_TEMPLATE_DOWNLOAD > consul-template.zip

logger "Installing Consul Template"
unzip consul-template.zip -d /usr/local/bin
chmod 0755 /usr/local/bin/consul-template
chown root:root /usr/local/bin/consul-template

logger "Fetching Consul Replicate"
logger $CONSUL_REPLICATE_DOWNLOAD
curl -L $CONSUL_REPLICATE_DOWNLOAD > consul-replicate.zip

logger "Installing Consul Replicate"
unzip consul-replicate.zip -d /usr/local/bin
chmod 0755 /usr/local/bin/consul-replicate
chown root:root /usr/local/bin/consul-replicate

logger "Fetching EnvConsul"
logger $ENVCONSUL_DOWNLOAD
curl -L $ENVCONSUL_DOWNLOAD > envconsul.zip

logger "Installing EnvConsul"
unzip envconsul.zip -d /usr/local/bin
chmod 0755 /usr/local/bin/envconsul
chown root:root /usr/local/bin/envconsul

logger "Installing Consul UI"
logger $CONSUL_WEBUI
curl -L $CONSUL_WEBUI > ui.zip
logger "Consul Dir"
logger $CONSUL_DIR
unzip ui.zip -d $CONSUL_DIR/ui

logger "Completed"
