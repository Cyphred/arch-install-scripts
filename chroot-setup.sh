# !/bin/sh
# Arch Setup Script
# Sets up arch in chroot after it has been installed.
# IMPORTANT: This script must only be run as root while chrooted
# Jeremy Andrews Zantua | jeremyzantua@gmail.com

# Make the colemak layout persistent
printf "Do you want colemak to be the default keymap? (yNe): "
read INPUT
if [ "${INPUT,,}" == "y" ]; then
	printf "KEYMAP=colemak" >> /etc/vconsole.conf || exit 1
elif [ "${INPUT,,}" == "e" ]; then
	exit
fi
unset INPUT

# Setting the hostname
while true; do
	printf "Enter your hostname: "
	read INNAME
	# Check if the input is not empty, store the input
	if [ ! -z "$INNAME" ]; then 
		printf "Are you sure you want to set \"$INNAME\" as your hostname? (yNe): "
		read INPUT 
		if [ "${INPUT,,}" == "y" ]; then
			printf "$INNAME" >> /etc/hostname &&
			printf "127.0.0.1\tlocalhost\n::1\t\tlocalhost\n127.0.1.1\t$INNAME.localdomain\t$INNAME" >> /etc/hosts &&
			break || exit 1
		elif [ "${INPUT,,}" == "e" ]; then
			exit
		fi
	else
		printf "ERROR: The hostname cannot be blank!\n"
	fi
done
unset INPUT

# Set the time zone by creating a symlink
printf "Setting the time zone to Asia/Manila...\n"
ln -sf /usr/share/zoneinfo/Asia/Manila /etc/localtime || exit 1

# Generate /etc/adjtime and sets the hardware clock to the current system time
printf "Setting the hardware clock to match the system clock...\n"
hwclock --systohc || exit 1

# Uncomments en_US.UTF-8 from locale.gen and generates a locale
printf "Uncommenting \'en_US.UTF-8 UTF-8\' from locale.gen...\n"
sed -i 's/#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/g' /etc/locale.gen &&
locale-gen &&
printf "LANG=en_US.UTF-8" >> /etc/locale.conf || exit 1

# Set the root password
printf "Set the root password. You have 3 attempts.\n"
for i in {1..3}
do
	passwd && break || exit
done

# Enable networkmanager if it is installed
printf "Enabling networkmanager...\n"
pacman -Q networkmanager && systemctl enable NetworkManager.service || exit 1

# Enable acpi and acpid if they are installed
pacman -Q acpi && pacman -Q acpid && systemctl enable acpid.service

# Enable TLP if it is installed
printf "Enabling TLP...\n"
pacman -Q tlp &&
sed -i 's/#START_CHARGE_THRESH_BAT0=.*/START_CHARGE_THRESH_BAT0=46/g' /etc/pacman.conf &&
sed -i 's/#STOP_CHARGE_THRESH_BAT0=.*/STOP_CHARGE_THRESH_BAT0=50/g' /etc/pacman.conf
systemctl enable tlp.service

# Adds a user
while true; do
	printf "Enter the name of the user: "
	read INNAME
	# Check if the input is not empty, store the input
	if [ ! -z "$INNAME" ]; then 
		printf "Are you sure you want to set \"$INNAME\" as your username? (yNe): "
		read INPUT 
		if [ "${INPUT,,}" == "y" ]; then
			useradd -m $INNAME &&
			passwd $INNAME &&
			INUNAME="$INNAME" &&
			break || exit 1
		elif [ "${INPUT,,}" == "e" ]; then
			exit
		fi
	else
		printf "ERROR: The username cannot be blank!\n"
	fi
done

# Check if sudo is installed and add the user to groups
printf "Adding $INUNAME to groups...\n"
pacman -Q sudo && usermod -aG wheel,audio,video,optical,storage $INUNAME || exit 1

# Edit the sudoers file
visudo || exit 1

# Check if grub and efibootmgr is installed
printf "Creating mount point and mounting the efi partition...\n"
mkdir /mnt/efi
mount /dev/sda1 /mnt/efi &&
pacman -Q grub && pacman -Q efibootmgr &&
grub-install /dev/sda --efi-directory=/mnt/efi &&
grub-mkconfig -o /boot/grub/grub.cfg || exit 1

printf "Setup script complete.\n"
