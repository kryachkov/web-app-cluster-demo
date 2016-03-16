# Simple web app claster powered by serf

## How to

Clone this repo

`$ git clone git@github.com:kryachkov/web-app-cluster-demo.git`

Set it up with Vagrant

`$ vagrant up`

Open http://192.168.33.10 in your browser and see that load balancer proxies your request to app.

![app_works_ok](https://www.dropbox.com/s/av1hxdii6awgsvi/Screenshot%202016-03-16%2018.50.48.png?dl=1)

Bring db node down

`$ vagrant halt db`

Hit http://192.168.33.10 and see the fancy maintenance node page

![maintenance_mode](https://www.dropbox.com/s/wffjx3f198uv99a/Screenshot%202016-03-16%2018.53.24.png?dl=1)

Bring db node up again

`$ vagrant up db`

Hit http://192.168.33.10 again and see response from app node

![app_works_ok](https://www.dropbox.com/s/av1hxdii6awgsvi/Screenshot%202016-03-16%2018.50.48.png?dl=1)

This is an extremely simple demonstration of one of many things that can be done using [Hashicop's Serf](https://github.com/hashicorp/serf)
