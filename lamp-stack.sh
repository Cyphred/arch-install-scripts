# !/bin/sh

[ "$EUID" -ne 0 ] && echo Missing root privileges && exit 1

pacman -S apache mariadb php php-cgi php-gd php-pgsql php-apache

# Enable modules in Apache
apache_config="/etc/httpd/conf/httpd.conf"
comment_line() {
	sed -i "s/$1/#$1/g" $apache_config
}
uncomment_line() {
	sed -i "s/#$1/$1/g" $apache_config
}
comment_line "LoadModule mpm_event_module modules/mod_mpm_event.so"
uncomment_line "LoadModule mpm_prefork_module modules/mod_mpm_prefork.so"

printf "\nLoadModule php_module modules/libphp.so\nAddHandler php-script .php\n"
