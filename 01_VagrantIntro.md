# Vagrant Introduction

## Introduction 

Vagrant c'est un gestionnaire de VM, qui va nous permettre de dupliquer facilement et de manière
reproductible un environment de dévelopment

Contrairement à Docker qui fonctionne par containerisation ici ce sont des machines virtuelle complète qui
sont déployée.

L'avantage par rapport à Docker réside dans le type d'infrastructure finale :
- Si l'infrastructure finale est une infrastructure physique, 
il se peut que certaines choses fonctionnent dans les containers mais pas dans la prod.
- Dans ce cas il est plus intéressent de simuler l'infrastructure de prod directement sur des vms

Donc Vagrant, n'est pas vraiment un concurent de Docker, ils ont des applications différentes.

### Attention Vagrant est un gestionnaire de VM pas un hypervisor !

Celà signifie que Vagrant seul ne peut pas lancer de VM, il lui faudra un hypervisor :

https://developer.hashicorp.com/vagrant/docs/providers

Il peut fonctionner avec : 
- libvrit (linux)
- virtual box
- VMWare
- Hyper-V

## Installation : 

https://developer.hashicorp.com/vagrant/install

Initialiser un projet test : 

```bash
vagrant init hashicorp/bionic64
```

Démarrer une vm vagrant :

```bash
vagrant up
```

Installation d'un provider (pour lancer les vms)

Liste des plugins disponibles : https://github.com/hashicorp/vagrant/wiki/Available-Vagrant-Plugins#providers

# Libvirt (linux only)
```shell
vagrant plugin install vagrant-libvirt
```

# VirtualBox
```shell
# installer les outils "Guest Addition"
vagrant plugin install vagrant-vbguest
```

# VmWare
```shell
vagrant plugin install vagrant-vmware-utility vagrant-vmware-desktop
```

## Plug ins intéressent 

hostsupdater permet de mettre à jours le fichier hosts du système hote pour résoudre les
noms de domaines des machines vagrant
```shell
vagrant plugin install vagrant-hostsupdater
```

Le vagrant-triggers va permettre de lancer des scripts avant où après certains évenement
(par exemple un "vagrant up")
```shell
vagrant plugin install vagrant-triggers
```

## Fonctionnement 

L'idée de vagrant c'est qu'on va avoir un fichier Vagrantfile qui va nous permettre de configurer la/les
machines virtuelles du projet.

Démarrer la vm
```shell
vagrant up
```

On peut aussi sélectionner un provider particulier : 
```shell
vagrant up --provider=libvirt
```

Se connecter en SSH :
```shell
vagrant ssh
```

Une autre méthode est de récupérer la configuration ssh :
```shell
vagrant ssh-config
```

```terminaloutput
Host default
  HostName 127.0.0.1
  User vagrant
  Port 2222
  UserKnownHostsFile /dev/null
  StrictHostKeyChecking no
  PasswordAuthentication no
  IdentityFile /home/USERNAME/WebstormProjects/vagrant/.vagrant/machines/default/virtualbox/private_key
  IdentitiesOnly yes
  LogLevel FATAL
  PubkeyAcceptedKeyTypes +ssh-rsa
  HostKeyAlgorithms +ssh-rsa
```

On conseil d'enregistrer la configuration ssh dans un fichier :
```shell
vagrant ssh-config > vagrant-ssh
```

Ici je dis que je veux me connecter via ssh en utilisant la configuration se trouvant 
dans "vagrant-ssh" et je veux utiliser l'host "default"
```shell
ssh -F vagrant-ssh default 
```