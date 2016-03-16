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

exec /usr/local/bin/serf agent  -event-handler "member-join=/etc/serf/member-join.sh"  -event-handler "member-leave,member-failed=/etc/serf/member-leave.sh"  -bind=192.168.33.10 -node=lb01 -tag role=lb >> /var/log/serf.log 2>&1
EOF
sudo mv serf-agent.conf /etc/init/serf-agent.conf

sudo mkdir -p /etc/serf

cat <<EOF >member-join.sh
#!/bin/bash

if [ $SERF_TAG_ROLE="db" ]; then
    rm /usr/share/nginx/html/maintenance.txt
fi
EOF
sudo mv member-join.sh /etc/serf/member-join.sh
sudo chmod +x /etc/serf/member-join.sh

cat <<EOF >member-leave.sh
#!/bin/bash

if [ $SERF_TAG_ROLE="db" ]; then
    touch /usr/share/nginx/html/maintenance.txt
fi
EOF
sudo mv member-leave.sh /etc/serf/member-leave.sh
sudo chmod +x /etc/serf/member-leave.sh

sudo start serf-agent

cat <<EOF >default
server {
  listen 80 default_server;

  root /usr/share/nginx/html;
  index index.html index.htm;

  server_name localhost;

  location / {
    if (-f \$document_root/maintenance.txt) {
      return 503;
    }

    proxy_pass http://192.168.33.12:80/;
  }

  error_page 503 @maintenance;

  location @maintenance {
    rewrite ^(.*)$ /maintenance.html break;
  }
}
EOF
sudo mv default /etc/nginx/sites-available/default
sudo service nginx reload

cat << EOF >maintenance.html
<!DOCTYPE html>
<html>
  <head>
    <title>Welcome to nginx!</title>
  </head>
  <body>
    <h1>Sorry, we are performing DB maintenance</h1>
  </body>
</html>
EOF
sudo mv maintenance.html /usr/share/nginx/html/maintenance.html
sudo service nginx reload
