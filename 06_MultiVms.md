# Définir plusieurs vms

```ruby
Vagrant.configure("2") do |config|
   config.vm.define "NOM_DE_LA_VM" do |NOM_DE_LA_VM|
     NOM_DE_LA_VM.vm.box = "ubuntu/focal64"
   end
end
```

Exemple : 
```ruby
Vagrant.configure("2") do |config|
   config.vm.define "web" do |web|
     web.vm.box = "ubuntu/focal64"
   end
   
   config.vm.define "db" do |db|
     db.vm.box = "ubuntu/focal64"
   end
end
```

## Configuration du réseau :

```ruby
Vagrant.configure("2") do |config|
   config.vm.define "web" do |web|
     web.vm.box = "ubuntu/focal64"
     web.vm.network "forwarded_port", guest: 80, host: 8080
     web.vm.network "private_network", ip: "192.168.50.10"
   end
   
   config.vm.define "db" do |db|
     db.vm.box = "ubuntu/focal64"
     db.vm.network "private_network", ip: "192.168.50.20"
   end
end
```

## Provisioning 

```ruby
Vagrant.configure("2") do |config|
   config.vm.define "web" do |web|
     web.vm.box = "ubuntu/focal64"
     
     web.vm.network "forwarded_port", guest: 80, host: 8080
     web.vm.network "private_network", ip: "192.168.50.10"
     
     web.vm.provision "shell", inline: "sudo apt install nginx"
     
     web.vm.provision "ansible" do |ansible|
        ansible.playbook = "playbook.yml"
        # Ici je dis que je sélectionne la configuration web (- hosts: web)
        ansible.limit = "web"
     end
   end
   
   config.vm.define "db" do |db|
     db.vm.box = "ubuntu/focal64"
     db.vm.network "private_network", ip: "192.168.50.20"
     
     db.vm.provision "shell", inline: "sudo apt install postgresql"
     
     db.vm.provision "ansible" do |ansible|
        ansible.playbook = "playbook.yml"
        # Ici je dis que je sélectionne la configuration db (- hosts: db)
        ansible.limit = "db"
     end
   end
end
```

playbook.yml:
```yaml
- hosts: db
#  ...

- hosts: web
#  ...
```
