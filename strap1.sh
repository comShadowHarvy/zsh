#!/bin/sh
# strap1.sh - prep my system

echo "trizen for AUR support"
sudo pacman -S trizen 
trizen -S tizonia spotifyd iris sconsify mopidy-spotify ncureses mopidy-local ytmdl dnd-tools subtitles-printer-git netflix-qdesktop silos hwinfo powerpill opencl-nvidia-tkg snapd screenfetch neofetch zsh snapd yadm screenfetch neofetch emacs nano git-summary nerd-fonts-complete nerd-fonts-hack vdhcoapp atom-transparent code-transparent lib32-gtk3 lib32-libxslt ccache schedtool lib32-v4l-utils ghc cabal-install zfz a2sv aphopper apkstat apt2 auto-auto-complete biglybt-extreme-mod



echo "Enabling snapd support"
sudo systemctl enable --now snapd.socket
sudo ln -s /var/lib/snapd/snap /snap
echo "yadm pull of .dot files"
curl -L git.io/antigen > antigen.zsh
yadm clone https://github.com/jimbob343/zsh
yadm status
echo "cobal"
cabal update
cabal install base text directory filepath process
echo "antigen-hs"
git clone https://github.com/Tarrasch/antigen-hs.git ~/.zsh/antigen-hs/
echo "Snap install of skype and snapstore"
sudo snap install skype --classic
sudo snap install snap-store
echo "DOOM emacs"
git clone https://github.com/hlissner/doom-emacs ~/.emacs.d
~/.emacs.d/bin/doom install

sudo strap.sh
mkdir git
cd git
git clone https://github.com/0xApt/awesome-bbht
git clone https://github.com/luong-komorebi/Awesome-Linux-Software
git clone https://github.com/may215/awesome-termux-hacking
git clone https://github.com/BlackHacker511/BlackNET
git clone https://github.com/TryCatchHCF/Cloakify
git clone https://github.com/entynetproject/ehtools
git clone https://github.com/wuseman/EMAGNET
git clone https://github.com/MirkoLedda/git-summary
git clone https://github.com/The-Art-of-Hacking/h4cker
git clone https://github.com/Ha3MrX/Hacking
git clone https://github.com/mikaelkall/HackingAllTheThings
git clone https://github.com/thehackingsage/hacktronian
git clone https://github.com/MD3XTER/hide-me
git clone https://github.com/lucasfrag/Kali-Linux-Tools-Interface
git clone https://github.com/Sanix-Darker/Lazymuxer
git clone https://github.com/aron-tn/Mega-Bot
git clone https://github.com/Kharacternyk/pacwall
git clone https://github.com/SofianeHamlaoui/Pentest-Bookmarkz
git clone https://github.com/vonahisec/pentesting_scripts
git clone https://github.com/flubberding/ProtonUpdater
git clone https://github.com/MS-WEB-BN/t14m4t
git clone https://github.com/nullsecuritynet/tools
