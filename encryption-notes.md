# Notes on installing a fully-encrypted system
- Loaded kernel module `dm_crypt` via `modprobe`
- `cryptestup open --type plain /dev/sda cryptroot`
mkfs -t ext4 /dev/mapper/cryptroot
