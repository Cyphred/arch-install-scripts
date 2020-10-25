# !/bin/sh
# Arch Setup Script
# Sets up arch in chroot after it has been installed.
# IMPORTANT: This script must only be run as root while chrooted
# Jeremy Andrews Zantua | jeremyzantua@gmail.com

# Set the time zone by creating a symlink
ln -sf /usr/share/zoneinfo/Asia/Manila /etc/localtime

# Generate /etc/adjtime and sets the hardware clock to the current system time
hwclock --systohc

# Uncomments en_US.UTF-8 from locale.gen and generates a locale
sed -i 's/#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/g' /etc/locale.gen 
locale-gen
printf "LANG=en_US.UTF-8" >> /etc/locale.conf

# Make the colemak layout persistent
printf "Do you want colemak to be the default keymap? (yN): "
read INPUT
[ "${INPUT,,}" == y ] && printf "KEYMAP=colemak" >> /etc/vconsole.conf
unset INPUT

# Setting the hostname
while true; do
	printf "Enter your hostname: "
	read INNAME
	# Check if the input is not empty, store the input
	if [ ! -z "$INNAME" ]; then 
		printf "Are you sure you want to set \"$INNAME\" as your hostname? (yN): "
		read INPUT 
		if [ "${INPUT,,}" == "y" ]; then
			printf "$INNAME" >> /etc/hostname
			printf "127.0.0.1\tlocalhost\n::1\t\tlocalhost\n127.0.1.1\t$INNAME.localdomain\t$INNAME" >> /etc/hosts
			break
		fi
	else
		printf "ERROR: The hostname cannot be blank!\n"
	fi
done

# Set the root password
passwd

# Enable networkmanager if it is installed
printf "Enabling networkmanager...\n"
pacman -Q networkmanager && systemctl enable NetworkManager.service

# Adds a user
while true; do
	printf "Enter the name of the user: "
	read INNAME
	# Check if the input is not empty, store the input
	if [ ! -z "$INNAME" ]; then 
		printf "Are you sure you want to set \"$INNAME\" as your username? (yN): "
		read INPUT 
		if [ "${INPUT,,}" == "y" ]; then
			useradd $INNAME
			passwd $INNAME
			INUNAME="$INNAME"
			break
		fi
	else
		printf "ERROR: The username cannot be blank!\n"
	fi
done

# Check if sudo is installed and add the user to groups
printf "Adding $INUNAME to groups...\n"
pacman -Q sudo && usermod -aG wheel,audio,video,optical,storage $INUNAME

# Edit the sudoers file
visudo

# Check if grub and efibootmgr is installed
pacman -Q grub && pacman -Q efibootmgr && grub-install /dev/sda --efi-directory=/mnt/efi && grub-mkconfig -o /boot/grub/grub.cfg

printf "Setup script complete."



