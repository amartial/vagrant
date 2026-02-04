# TP Final : Infrastructure Multi-Tiers avec Vagrant & Ansible

## 🎯 Objectif
L'objectif de ce projet est de simuler un environnement de production complet et sécurisé. Vous devez automatiser le déploiement d'une application découpée en micro-services sur trois machines virtuelles distinctes.

---

## 🏗️ Architecture du Système

L'infrastructure est composée de trois serveurs sous **Ubuntu 20.04 (Focal)** :

1.  **Frontend (`frontend`)**
    * **Rôle** : Serveur Web (NodeJS) servant l'interface utilisateur.
    * **Réseau** : IP Privée `192.168.56.20` + Port Forwarding (`1980` invité -> `3001` hôte).
2.  **Backend (`backend`)**
    * **Rôle** : API Express (Node.js) traitant la logique métier.
    * **Réseau** : IP Privée `192.168.56.21` + Port Forwarding (`3000` invité -> `3000` hôte)..
3.  **Database (`database`)**
    * **Rôle** : Stockage des données (PostgreSQL) + Administration (pgAdmin4).
    * **Réseau** : IP Privée `192.168.56.22`. *Note : Cette machine n'est pas exposée directement sur l'hôte.*

---

## 🛠️ Consignes de réalisation

### 1. Configuration Vagrant
* Définissez les trois machines dans un seul `Vagrantfile`.
* **Provisioning Shell** : Toutes les machines doivent être mises à jour (`apt update`) et posséder `git` et `curl`.
* **Provisioning Ansible** : Le reste de la configuration doit être géré par un playbook Ansible.

### 2. Missions du Playbook Ansible

#### **🌐 Machine Frontend**
* Installer **Node.js** et **NPM**.
* Cloner le dépôt Git https://github.com/phil-form/balrog-js.
* Replacer la chaine de caractère suivante `#@#{BACK_IP}#@#` par l'IP du back
* Installer les dépendances (`npm install`) et démarrer l'application (ex: via `npm start`).

#### **⚙️ Machine Backend**
* Installer **Node.js** et **NPM**.
* Cloner le dépôt Git https://github.com/phil-form/backend.
* Replacer la chaine de caractère suivante `#@#{DB_HOST}#@#` par l'IP de la db
* Replacer la chaine de caractère suivante `#@#{DB_USER}#@#` par l'utilisateur de la db
* Replacer la chaine de caractère suivante `#@#{DB_PASSWORD}#@#` par le password de l'utilisateur
* Replacer la chaine de caractère suivante `#@#{DB_NAME}#@#` par le nom de la db
* Installer les dépendances (`npm install`) et démarrer l'application (ex: via `npm start`).

#### **🗄️ Machine Database**
* **PostgreSQL** :
    * Installer le serveur et ses dépendances.
    * Configurer le service pour écouter sur l'IP privée (`192.168.56.22`).
    * **Sécurité** : Modifier le fichier `pg_hba.conf` pour n'autoriser QUE l'IP du Backend à se connecter.
* **pgAdmin4** :
    * Ajouter le dépôt officiel et la clé GPG de pgAdmin.
    * Installer `pgadmin4-web`.
  * Automatiser la configuration initiale (Email: `admin@admin.com` / MDP: `password123`).

---

## 🔐 Sécurité et Flux
* Le **Frontend** doit être configuré pour appeler l'API sur `192.168.56.21`.
* Le **Backend** doit se connecter à la DB sur `192.168.56.22`.
* La **Database** n'est accessible que par le Backend ou via l'interface Web pgAdmin.

---

## 🏁 Validation du TP

Votre projet est réussi si :
1.  `http://localhost:3001` affiche votre interface Frontend.
2.  `http://localhost:8080/pgadmin4` est accessible depuis votre navigateur.
3.  Vous pouvez vous connecter à pgAdmin et ajouter le serveur PostgreSQL local (`127.0.0.1`).
4.  L'ensemble du déploiement se fait en une seule commande : `vagrant up`.

---

> **Aide Mémoire :** Pour pgAdmin, utilisez le script `/usr/pgadmin4/bin/setup-web.sh` avec l'option `--yes` pour l'automatisation.
