# !/bin/sh
# Arch Install Script
# Downloads and installs the base arch linux and my essential packages
# Jeremy Andrews Zantua | jeremyzantua@gmail.com

printf "Modifying pacman.conf...\n"
sed -i 's/#Color/Color/g' /etc/pacman.conf &&
sed -i 's/#TotalDownload/TotalDownload/g' /etc/pacman.conf &&
sed -i 's/#VerbosePkgLists/VerbosePkgLists/g' /etc/pacman.conf || exit 1

printf "Creating a mirrorlist using the mirrors from the nearest countries...\n"
reflector --country Philippines --country 'Hong Kong' --country Taiwan --country Japan --country Singapore --country Indonesia --save /etc/pacman.d/mirrorlist || exit 1

printf "Installing linux and essential packages...\n"
pacstrap /mnt base linux linux-firmware networkmanager base-devel git vim sudo grub efibootmgr wget htop tmux openssh ranger tlp acpi_call man || exit 1

printf "Creating an fstab file...\n"
genfstab -U /mnt >> /mnt/etc/fstab || exit 1

printf "Install script complete\n"
