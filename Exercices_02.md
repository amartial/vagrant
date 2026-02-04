# TP Vagrant & Ansible : Architecture 2-Tier (Multi-VM)

## Problématique
Dans une architecture réelle, on ne mélange pas le serveur Web et la base de données sur la même machine pour des raisons de sécurité et de scalabilité. Nous allons séparer notre monolithe en deux serveurs distincts.

## Objectif
Déployer une infrastructure avec deux machines virtuelles communiquant sur un réseau privé isolé.

## Consignes

### 1. Architecture des VMs
Modifiez votre `Vagrantfile` pour définir deux machines distinctes :

**B. VM "webapp"**
* **Box :** `ubuntu/focal64`
* **IP Privée :** `192.168.56.12`
* **Port Forwarding :** 80 (guest) -> 8080 (host).
* **Provisioning :** Ansible (uniquement pour installer Nginx).

**A. VM "database"**
* **Box :** `ubuntu/focal64`
* **IP Privée :** `192.168.56.10`
* **Provisioning :** Ansible (uniquement pour installer PostgreSQL).

**B. VM "pgadmin4"**
* **Box :** `ubuntu/focal64`
* **IP Privée :** `192.168.56.11`
* **Port Forwarding :** 5050 (guest) -> 8081 (host).
* **Provisioning :** Ansible installer pgadmin4.

### 2. Provisioning Shell Global
Configurez un provisioning `shell` qui s'exécute sur **les deux machines** pour faire un `apt-get update`.

### 3. Playbook Ansible Multi-Hôtes
Mettez à jour votre `playbook.yml`. Il doit maintenant contenir deux blocs distincts (deux "plays") :
* Le premier ciblant le groupe `database`.
* Le second ciblant le groupe `pgadmin4`.

*Astuce : Utilisez `ansible.limit` dans le Vagrantfile pour lier chaque VM à son groupe Ansible.*

## Validation
1. Exécutez `vagrant up`.
2. Vérifiez que `http://localhost:8080` fonctionne toujours.
3. **Le Test de connectivité :**
    * Connectez-vous à la VM webapp : `vagrant ssh webapp`.
    * Tentez de "pinguer" la base de données : `ping 192.168.56.10`.
    * La communication doit fonctionner !


----------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------


# Correction

Vagrantfile :
```ruby
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
```

playbook.yml :
```yaml
- hosts: webapp
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

    - name: "Configurer index.html"
      copy:
        dest: /var/www/html/index.html
        src: index.html
        mode: 0644

- hosts: db
  become: true

  tasks:
    - name: Install postgresql
      apt:
        name: postgresql
        state: present

    - name: Demarrer postgresql
      service:
        name: postgresql
        state: started
        enabled: yes

- hosts: pgadmin
  become: true

  tasks:
    - name: Install Pgadmin4 dependencies
      apt:
        name:
          - curl
          - ca-certificates
          - gpg
        state: present
        update_cache: yes

    - name: Download pgAdmin GPG key
      get_url:
        url: https://www.pgadmin.org/static/packages_pgadmin_org.pub
        dest: /usr/share/keyrings/pgadmin-keyring.gpg
        mode: '0644'

    - name: Add pgAdmin repository
      apt_repository:
        repo: >
          deb [signed-by=/usr/share/keyrings/pgadmin-keyring.gpg]
          https://ftp.postgresql.org/pub/pgadmin/pgadmin4/apt/{{ ansible_distribution_release }}
          pgadmin4 main
        state: present
        filename: pgadmin4

    - name: Install Pgadmin4
      apt:
        name: [pgadmin4-web, pgadmin4-server, postgresql-client]
        state: present
        update_cache: yes

    - name: Configure PGadmin4 web
      environment:
        PGADMIN_SETUP_EMAIL: "test@test.com"
        PGADMIN_SETUP_PASSWORD: "Password1234!"
      shell: "/usr/pgadmin4/bin/setup-web.sh --yes"
      args:
        # Si /etc/apache2/conf-enabled/pgadmin4.conf existe, alors il ne réexécute pas le script.
        creates: /etc/apache2/conf-enabled/pgadmin4.conf

```

install_pgadmin.sh :
```shell
sudo apt update
sudo apt install curl gpg -y

curl -fsS https://www.pgadmin.org/static/packages_pgadmin_org.pub | sudo gpg --dearmor -o /usr/share/keyrings/packages-pgadmin-org.gpg

sudo sh -c 'echo "deb [signed-by=/usr/share/keyrings/packages-pgadmin-org.gpg] https://ftp.postgresql.org/pub/pgadmin/pgadmin4/apt/$(lsb_release -cs) pgadmin4 main" > /etc/apt/sources.list.d/pgadmin4.list && apt update'
sudo apt install pgadmin4-web pgadmin4-server postgresql-client -y

export PGADMIN_SETUP_EMAIL="test@test.com"
export PGADMIN_SETUP_PASSWORD="Password1234!"

sudo --preserve-env=PGADMIN_SETUP_EMAIL,PGADMIN_SETUP_PASSWORD /usr/pgadmin4/bin/setup-web.sh --yes

```

