# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "bento/debian-13"

  # Provisioning Shell commun (Bootstrap)
  config.vm.provision "shell", inline: <<-SHELL
    apt-get update
    apt-get install -y git curl acl
  SHELL

  # --- FRONTEND ---
  config.vm.define "frontend" do |f|
    f.vm.hostname = "frontend"
    f.vm.network "private_network", ip: "192.168.56.20"
    f.vm.network "forwarded_port", guest: 1980, host: 3001
    f.vm.provision "ansible" do |ansible|
      ansible.playbook = "playbook.yml"
      ansible.limit = "frontend"
    end
  end

  # --- DATABASE ---
  # !!! La machine "database" doit être démarrée avant "backend" !!!
  config.vm.define "database" do |d|
    d.vm.hostname = "database"
    d.vm.network "private_network", ip: "192.168.56.22"
    # Port 80 pour pgAdmin (servi par Apache) exposé sur 8080 pour la validation
    d.vm.network "forwarded_port", guest: 80, host: 8080
    d.vm.provision "ansible" do |ansible|
      ansible.playbook = "playbook.yml"
      ansible.limit = "database"
    end
  end

  # --- BACKEND ---
  config.vm.define "backend" do |b|
    b.vm.hostname = "backend"
    b.vm.network "private_network", ip: "192.168.56.21"
    b.vm.network "forwarded_port", guest: 3000, host: 3000
    b.vm.provision "ansible" do |ansible|
      ansible.playbook = "playbook.yml"
      ansible.limit = "backend"
    end
  end
end
