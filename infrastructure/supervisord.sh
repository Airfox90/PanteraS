#!/bin/bash

feed(){
  sleep 20
  consul kv put panteras/http @/etc/fabio/errors/panteras.http
}

[ -z ${HOST_IP} ] || {
  feed &
  exec supervisord -c /etc/supervisord.conf
}
. /etc/profile.d/logo.sh

cat << EOF
PanteraS - Platform as a Service
Usage:

$ git clone -b $version https://github.com/eBayClassifiedsGroup/PanteraS
$ cd PanteraS

# ------------------------------------------
# Stand Alone (Master & Slave):

$ ./generate_yml.sh
$ docker-compose up -d


# ------------------------------------------
# 3 Masters (without Slaves daemons):
# Repeat on every master docker host, but keep in mind to have ZOOKEEPER_ID uniq:

$ mkdir restricted
$ echo 'ZOOKEEPER_ID=1' >> restricted/host
$ echo 'ZOOKEEPER_HOSTS="master-1:2181,master-2:2181,master-3:2181"' >> restricted/host
$ echo 'CONSUL_HOSTS="-join=master-1 -join=master-2 -join=master-3"' >> restricted/host
$ echo 'MESOS_MASTER_QUORUM=2' >> restricted/host
$ echo 'SLAVE=false' >> restricted/host

# On first maser host ONLY set up consul bootstrap 
$ echo 'CONSUL_PARAMS="-bootstrap-expect 3"' >> restricted/host

$ ./generate_yml.sh
$ docker-compose up -d

# ------------------------------------------
# Add Slaves (Master need to be set up before)
# Repeat on each Slave docker host:

$ mkdir restricted
$ echo 'ZOOKEEPER_HOSTS="master-1:2181,master-2:2181,master-3:2181"' >> restricted/host
$ echo 'CONSUL_HOSTS="-join=master-1 -join=master-2 -join=master-3"' >> restricted/host
$ echo 'MASTER=false' >> restricted/host

$ ./generate_yml.sh
$ docker-compose up -d

more info and examples on github
EOF
