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
pacstrap /mnt base linux linux-firmware acpi acpid networkmanager base-devel git vim sudo grub os-prober efibootmgr wget htop tmux openssh ranger tlp acpi_call man ntfs-3g libxft xorg-server xorg-xinit xorg-xrandr xorg-xsetroot xorg-xbacklight arandr picom feh libxft libxinerama noto-fonts noto-fonts-cjk noto-fonts-emoji pulseaudio pavucontrol pamixer scrot dunst libnotify xdg-utils xf86-video-intel task lxappearance zathura zathura-cb zathura-pdf-mupdf cmus mpv udisks2 ||
exit 1

printf "Creating an fstab file...\n"
genfstab -U /mnt >> /mnt/etc/fstab || exit 1

printf "Install script complete\n"
