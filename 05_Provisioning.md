# Provisioning

## Qu'est-ce le provisioning : 

Objectifs : 
* Installer des logiciels
* Configurer des services
* Préparer la VM pour le developpement ou le test
* Grarantir que chaque machine est identique en tout point pour assurer la reproductibilité

## Les principaux Provisioners : 

1) Shell 

```ruby
Vagrant.configure("2") do |config|
    config.vm.box = "hashicorp/bionic64"

    config.vm.provision "shell", inline: <<-SHELL
        sudo apt install -y postgres
        sudo systemctl enable postgres
        sudo systemctl start postgres
    SHELL
end
```

2) Ansible 
```ruby
Vagrant.configure("2") do |config|
    config.vm.box = "hashicorp/bionic64"

    config.vm.provision "ansible" do |ansible|
        ansible.playbook = "playbook.yml"
    end
end
```

## Idempotence et reproductibilité

Exemple de problème d'idempotence : 
```shell
Vagrant.configure("2") do |config|
    config.vm.box = "hashicorp/bionic64"

    # Dans cet exemple on va partir sur le principe qu'avoir deux fois la 
    # valeur dans le fichier crée une erreur au sein du service
    config.vm.provision "shell", inline: <<-SHELL
        echo "unique_value" >> /etc/critical.conf
    SHELL
end
```

avec ansible :
```yml
- hosts: all
  become: true

  tasks:
    - name: "Configurer critical.conf"
      copy:
        dest: /etc/critical.conf
        content: "unique_value"
```

Avec Ansible, je m'assure que même en réexécutant le provisioning sur les VMs, que la configuration
reste dans le même état

Donc avec le shell le contenu de /etc/critical.conf après deux exécution du provisioning sera :
```terminaloutput
unique_value
unique_value
```

Pour provisioner : 

```shell
vagrant up --provision
```

Pour réexécuter le provisioning : 

```shell
vagrant provision
```

avec ANSIBLE : 

```terminaloutput
unique_value
```