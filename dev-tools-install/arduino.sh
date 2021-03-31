# !/bin/sh
# Installs and setups arduino-cli

[ "$EUID" -ne 0 ] && echo "This script must be run as root." && exit 1

_install() {
	while true; do
		pacman -S arduino-cli arduino-avr-core
		_is_installed && break
	done
}

_is_installed() {
	pacman -Qe arduino-cli arduino-avr-core
}

# Install arduino if it is not already installed
_is_installed || _install

# Check if the user is not a member of the uucp group yet
groups $USER | grep uucp || usermod -aG uucp $USER

# arduino-cli core install arduino:avr
