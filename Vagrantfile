# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
    config.vm.box = "ubuntu/focal64"

    # Dans cet exemple on va partir sur le principe qu'avoir deux fois la
    # valeur dans le fichier crée une erreur au sein du service
    config.vm.provision "shell", inline: <<-SHELL
        echo "unique_value" >> /etc/critical.conf
    SHELL

    config.vm.provision "ansible" do |ansible|
        ansible.playbook = "playbook.yml"

    end
end