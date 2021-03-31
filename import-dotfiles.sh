# !/bin/sh
# Imports dotfiles from a git repo

repo="https://github.com/Cyphred/i3rice.git"

git clone --bare $repo $HOME/.cfg
function config {
	/usr/bin/git --git-dir=$HOME/.cfg --work-tree=$HOME  $@
}
mkdir -p .config-backup
config checkout
if [ $? = 0 ]; then
	echo "Checked out config."
else
	echo "Backing up pre-existing dotfiles."
	config checkout 2>&1 | egrep "\s+\." | awk{'print $1'} | xargs -I{} mv {} .config-backup/{}
fi
config checkout
config config status.showUntrackedFiles no
