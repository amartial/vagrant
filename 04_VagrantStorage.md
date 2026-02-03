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
