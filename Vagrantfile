# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.box = "ubuntu/trusty64"

  config.vm.define 'lb' do |lb|
    lb.vm.network "private_network", ip: "192.168.33.10"

    lb.vm.provision 'shell', path: 'provision-lb.sh'
  end

  config.vm.define 'db' do |db|
    db.vm.network "private_network", ip: "192.168.33.11"

    db.vm.provision 'shell', path: 'provision-db.sh'
  end

  config.vm.define 'app' do |app|
    app.vm.network "private_network", ip: "192.168.33.12"

    app.vm.provision 'shell', path: 'provision-app.sh'
  end
end
