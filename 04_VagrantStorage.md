# Storage

## Sync folders

```ruby
# ici je lie le dossier ./src de mon hote au dossier /var/www/src de ma VM
config.vm.synced_folder "./src", "/var/www/src"
```

## rsync

```ruby
config.vm.synced_folder "./src", "/var/www/src", type "rsync"
```

## NFS (Network File System)

```ruby
config.vm.synced_folder "./src", "/var/www/src", type "nfs"
```


# Exercice :

Setup les propriétées suivantes :
* 4096MiB de RAM
* 4 Coeurs
* ouvrir les ports : 443 -> 443 (guest -> hote)  80 -> 8080 8080 -> 8081
* faire un partage en rsync d'un dossier /var/www/config ./config
* faire en partage NFS le dossier /var/www/src ->  ./src

```ruby
Vagrant.configure("2") do |config|
    config.vm.box = "hashicorp/bionic64"
    
    # ouvrir les ports : 443 -> 443 (guest -> hote)  80 -> 8080 8080 -> 8081
    config.vm.network "forwarded_port", guest: 443, host: 443
    config.vm.network "forwarded_port", guest: 80, host: 8080
    config.vm.network "forwarded_port", guest: 8080, host: 8081
    
    # * faire un partage en rsync d'un dossier /var/www/config ./config
    config.vm.synced_folder "./config", "/var/www/config", type: "rsync"
    
    # * faire en partage NFS le dossier /var/www/src ->  ./src
    config.vm.synced_folder "./src/", "/var/www/src", type: "nfs"

    # 4096MiB de RAM
    # 4 Coeurs
    config.vm.provider "virtualbox" do |vb|
        vb.memory = 4096
        vb.cpus = 4
    end 
end
```