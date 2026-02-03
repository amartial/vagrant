## Architecture globale : 

On a 4 briques principales sur lesquelles vagrant se repose : 
1) Vagrant CLI (Command line interface)
2) Vagrantfile (Fichier de configuration du projet)
3) Box (Wrapper autour vm créees)
4) Provider (VirtualBox/Libvirt/...)

## Configurer le projet via le Vagrantfile 

Le Vagrantfile c'est un fichier codé en ruby, qui nous permet de passer les configurations désirée
à la vagrant cli ce qui lui permet de créer les ressources.

Exemple d'une configuration de base

```ruby
Vagrant.configure("2") do |config|
  config.vm.box = "hashicorp/bionic64"
end
```

Pour la configuration, on ne doit ruby.

## Structure d'un vagrant file :

```ruby
Vagrant.configure("2") do |config|
    # Sélection de la box (image à déployer)
    config.vm.box = "hashicorp/bionic64"
    
    # Réseau :
    config.vm.network ...
    
    # Syncronisation de dossiers avec l'hote : 
    config.vm.synced_folder ...
    
    # Configuration du provider (exemple config de la RAM, nombre de coeur etc) :
    config.vm.provider ...
    
    # Provisoning (exemple executer des scripts d'installation après avoir créer la VM)
    config.vm.provision ...
end
```

## Les boxes

Une boxe est un OS préinstaller (similaire à une image docker)

Le format est compatible avec tous les providers disponible.

On pourra partir de cette image pour configurer notre environment.

### Roles des boxes

* Gagner du temps (l'OS est pré-installer/configurer, il ne reste plus qu'à installer nos services/applications)
* Standardiser l'OS (librairies installée/...)
* Garantir la reproductibilité

### Boxes officielles 

Les boxes officielles sont disponible sur Vagrant cloud

Avantages :
* Maintenance par des tiers sûr
* Sécurisées
* Simple et fiable

### Boxes custom 

Avantages : 
* Dans le cas où on a une configuration ou un OS spécifique on peut créer notre propre box
* Standardisation au travers de l'entreprises
* Démarrage rapide d'un projet (pas besoin de configurer les box)

Inconvénients : 
* Maintenance lourdes (c'est à vous de faire la maintenance)
* Versionning (dans ce cas il faut absolument versionner le projet)

### Les boxes en DevOps

Généralement on va préférer partir d'une box minimaliste (le plus souvent disponible sur le cloud)
et ensuite on utilise le provisioning pour setup l'environment.

## Les Providers

Role d'un provider : 
* Créer
* Démarrer
* Arrêter
* Détruire

### Configuration d'un provider

Virtual box (par défaut)
```ruby
config.vm.provider "virtualbox" do |vb|
    vb.memory = 2048
    vb.cpus = 2
end
```

Libvirt :
```ruby
config.vm.provider :libvirt do |lv|
    lv.memory = 2048
    lv.cpus = 2
end
```

## Cycle de vie :


| commande        | effet                                          |
|:----------------|:-----------------------------------------------|
| vagrant up      | démarre la VM                                  |
| vagrant halt    | arrete la VM                                   |  
| vagrant reload  | rédemarrer et recharger la configuration la VM |  
| vagrant destroy | détruire la VM                                 |  



## Exercice 

Créer une VM avec les propriétées suivantes :
* 4096MiB de RAM
* 4 Coeurs

```ruby
Vagrant.configure("2") do |config|
    config.vm.box = "hashicorp/bionic64"

    config.vm.provider "virtualbox" do |vb|
        vb.memory = 4096
        vb.cpus = 4
    end 
end
```