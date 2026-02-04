Vagrant.configure("2") do |config|
   config.vm.define "web" do |web|
     web.vm.box = "ubuntu/focal64"
     
     web.vm.network "forwarded_port", guest: 80, host: 8080
     web.vm.network "private_network", ip: "192.168.56.11"
     
     web.vm.provision "shell", inline: "sudo apt install vim curl"
     
     web.vm.provision "ansible" do |ansible|
        ansible.playbook = "playbook.yml"
        # Ici je dis que je sélectionne la configuration web (- hosts: web)
        ansible.limit = "web"
     end
   end
   
   config.vm.define "db" do |db|
     db.vm.box = "ubuntu/focal64"
     db.vm.network "private_network", ip: "192.168.56.20"
     
     db.vm.provision "shell", inline: "sudo apt install vim curl"
     
     db.vm.provision "ansible" do |ansible|
        ansible.playbook = "playbook.yml"
        # Ici je dis que je sélectionne la configuration db (- hosts: db)
        ansible.limit = "db"
     end
   end
end
