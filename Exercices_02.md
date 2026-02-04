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
