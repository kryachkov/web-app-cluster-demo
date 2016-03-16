#!/bin/bash

sudo apt-get install -y unzip
cd /tmp
wget https://releases.hashicorp.com/serf/0.7.0/serf_0.7.0_linux_amd64.zip
unzip serf_0.7.0_linux_amd64.zip
sudo chmod +x serf
sudo mv serf /usr/local/bin

sudo apt-get install -y nginx

cd /tmp

cat <<EOF >serf-agent.conf
description "Serf agent"
start on runlevel [2345]
stop on runlevel [!2345]

exec /usr/local/bin/serf agent -bind=192.168.33.12 -node=app01 -tag role=app >> /var/log/serf.log 2>&1
EOF
sudo mv serf-agent.conf /etc/init/serf-agent.conf
sudo start serf-agent

cat <<EOF >serf-join.conf
description "Join the serf cluster"
start on runlevel [2345]
stop on runlevel [!2345]
task
respawn
script
    sleep 5
    exec /usr/local/bin/serf join 192.168.33.10
end script
EOF
sudo mv serf-join.conf /etc/init/serf-join.conf
sudo start serf-join

cat <<EOF >index.html
<!DOCTYPE html>
<html>
  <head>
    <title>Welcome to nginx!</title>
  </head>
  <body>
    <h1>Hello from app node</h1>
  </body>
</html>
EOF
sudo mv index.html /usr/share/nginx/html/index.html
