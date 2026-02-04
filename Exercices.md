# TP Vagrant : Le Serveur Monolithique

## Objectif
L'objectif de ce TP est de créer un environnement de développement standardisé. Vous allez configurer une machine virtuelle unique qui hébergera à la fois un serveur Web et une base de données.

## Pré-requis
* Vagrant installé.
* VirtualBox installé.
* Ansible installé sur votre machine hôte.

## Consignes

### 1. Initialisation
Créez un dossier `tp-monolithe` et initialisez un projet Vagrant utilisant la box `ubuntu/focal64`.

### 2. Configuration Réseau
Configurez le transfert de port (Port Forwarding) pour que le port **80** de la VM soit accessible via le port **8080** de votre machine physique.

### 3. Provisioning Shell (Bootstrap)
Dans votre `Vagrantfile`, ajoutez un bloc de provisioning `shell` qui effectue les actions suivantes :
* Mise à jour des dépôts (`apt-get update`).
* Installation des outils `curl` et `vim`.

### 4. Provisioning Ansible (Configuration logicielle)
Créez un fichier `playbook.yml` et configurez Vagrant pour l'utiliser. Le playbook doit :
* Installer **Nginx**.
* Installer **PostgreSQL**.
* S'assurer que les deux services sont démarrés (`started`) et activés au boot (`enabled`).
* **Bonus :** Créer un fichier `index.html` sur votre hôte et utiliser le module `copy` d'Ansible pour remplacer la page par défaut de Nginx dans `/var/www/html/index.nginx-debian.html`.

## Validation
1. Lancez la machine avec `vagrant up`.
2. Vérifiez l'accès à la page web sur `http://localhost:8080` depuis votre navigateur.
3. Connectez-vous en SSH (`vagrant ssh`) et vérifiez que le service postgres est actif : `systemctl status postgresql`.


--------------------------------------------------------------------------------------------------------------


## Correction : 

Layout des fichiers : 

```terminaloutput
exercice_monolithe/
├── Vagrantfile
├── playbook.yml
└── index.html
```

Vagrantfile
```ruby
Vagrant.configure("2") do |config|
    config.vm.box = "ubuntu/focal64"

    config.vm.network "forwarded_port", guest: 80, host: 8080

    config.vm.provision "shell", inline: <<-SHELL
        echo "Mise à jours du système..."
        apt update
        apt install -y curl vim
    SHELL

    config.vm.provision "ansible" do |ansible|
        ansible.playbook = "playbook.yml"
    end
end
```

playbook.yml
```yaml
- hosts: all
  become: true

  tasks:
    - name: Install nginx
      apt:
        name: nginx
        state: present

    - name: Demarrer nginx
      service:
        name: nginx
        state: started
        enabled: yes

    - name: Install postgresql
      apt:
        name: postgresql
        state: present

    - name: Demarrer postgresql
      service:
        name: postgresql
        state: started
        enabled: yes

    - name: "Configurer index.html"
      copy:
        dest: /var/www/html/index.html
        src: index.html
        mode: 0644
```

index.html
```html
<h1>La plus belle page du monde !</h1>
```
