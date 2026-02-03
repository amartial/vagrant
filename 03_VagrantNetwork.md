# Networking

## Port forwarding

On va pouvoir faire un port forwarding entre l'hote et la VM :
```ruby
# Donc ici je re-route le port 8080 de ma machine hôte vers le port 80 de la VM
config.vm.network "forwarded_port", guest: 80, host: 8080
```

## Private network

```ruby
config.vm.network "private_network", ip: "192.168.36.10"
```

## Public network

Rendre la VM accessible de l'extérieur (sur le réseau de l'hote)
```ruby
config.vm.network "public_network"
```