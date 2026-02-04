Vagrant.configure("2") do |config|
   config.vm.define "webapp" do |webapp|
     webapp.vm.box = "cloud-image/debian-13"
     
     webapp.vm.network "forwarded_port", guest: 80, host: 8080
     webapp.vm.network "private_network", ip: "192.168.56.12"
     
     webapp.vm.provision "shell", inline: "sudo apt update"
#      webapp.vm.provision "shell", path: "./myscript.sh"

     webapp.vm.provision "ansible" do |ansible|
        ansible.playbook = "playbook.yml"
        # Ici je dis que je sélectionne la configuration web (- hosts: webapp)
        ansible.limit = "webapp"
     end
   end
   
   config.vm.define "db" do |db|
     db.vm.box = "ubuntu/focal64"
     db.vm.network "private_network", ip: "192.168.56.10"
     
     db.vm.provision "shell", inline: "sudo apt install vim curl"
     
     db.vm.provision "ansible" do |ansible|
        ansible.playbook = "playbook.yml"
        # Ici je dis que je sélectionne la configuration db (- hosts: db)
        ansible.limit = "db"
     end
   end

  config.vm.define "pgadmin" do |pgadmin|
     pgadmin.vm.box = "cloud-image/debian-13"

     pgadmin.vm.network "forwarded_port", guest: 443, host: 8081
     pgadmin.vm.network "forwarded_port", guest: 80, host: 8082
     pgadmin.vm.network "private_network", ip: "192.168.56.11"

#      pgadmin.vm.provision "shell", path: "install_pgadmin.sh"

     pgadmin.vm.provision "ansible" do |ansible|
        ansible.playbook = "playbook.yml"
        # Ici je dis que je sélectionne la configuration web (- hosts: pgadmin)
        ansible.limit = "pgadmin"
     end
   end
end
