#!/bin/sh
# strap1.sh - prep my system

echo "trizen for AUR support"
sudo pacman -S trizen 
trizen -S tizonia spotifyd iris sconsify mopidy-spotify ncureses mopidy-local ytmdl dnd-tools subtitles-printer-git netflix-qdesktop silos hwinfo powerpill opencl-nvidia-tkg snapd screenfetch neofetch zsh snapd yadm screenfetch neofetch emacs nano
echo "Enabling snapd support"
sudo systemctl enable --now snapd.socket
sudo ln -s /var/lib/snapd/snap /snap
echo "DOOM emacs"
git clone https://github.com/hlissner/doom-emacs ~/.emacs.d
~/.emacs.d/bin/doom install
sudo snap install skype --classic
sudo snap install snap-store
sudo strap.sh
