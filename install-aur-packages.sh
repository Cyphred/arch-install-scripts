# !/bin/sh
# Installs yay and uses it to install essential packages from the AUR

installPackages() {
	yay bashmount
	yay tremc
}

[ -d "$HOME/packages" ] || mkdir $HOME/packages/
cd $HOME/packages
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -sci && installPackages
cd $HOME
