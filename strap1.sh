#!/bin/sh
# strap1.sh - prep my system
######CHAOTIC AUR Support
echo "CHAOTIC AUR Support"
sudo cat >> "/etc/pacman.conf" << EOF
[chaotic-aur]
Server = http://lonewolf-builder.duckdns.org/$repo/x86_64
Server = http://chaotic.bangl.de/$repo/x86_64
Server = https://repo.kitsuna.net/x86_64
#########################Must add keys for it
#sudo pacman-key --keyserver keys.mozilla.org -r 3056513887B78AEB
#sudo pacman-key --lsign-key 3056513887B78AEB
EOF

sudo pacman-key --keyserver keys.mozilla.org -r 3056513887B78AEB
sudo pacman-key --lsign-key 3056513887B78AEB


echo "trizen for AUR support"
sudo pacman -S trizen zsh
trizen -S tizonia 
trizen -S git 
trizen -S spotifyd 
trizen -S iris 
trizen -S sconsify 
trizen -S mopidy-spotify 
trizen -S ncureses 
trizen -S mopidy-local 
trizen -S ytmdl 
trizen -S dnd-tools 
trizen -S subtitles-printer-git 
trizen -S netflix-qdesktop 
trizen -S silos 
trizen -S hwinfo 
trizen -S powerpill 
trizen -S opencl-nvidia-tkg 
trizen -S snapd 
trizen -S screenfetch 
trizen -S neofetch 
trizen -S pfetch 
trizen -S archey4 
trizen -S snapd 
echo "Enabling snapd support"
sudo systemctl enable --now snapd.socket
sudo ln -s /var/lib/snapd/snap /snap
trizen -S yadm
yadm clone http://github.com/jimbob343/zsh
trizen -S screenfetch 
trizen -S neofetch 
trizen -S emacs 
trizen -S nano 
trizen -S git-summary 
trizen -S nerd-fonts-complete 
trizen -S nerd-fonts-hack 
trizen -S vdhcoapp 
trizen -S atom-transparent 
trizen -S code-transparent 
trizen -S lib32-gtk3 
trizen -S lib32-libxslt 
trizen -S ccache 
trizen -S schedtool 
trizen -S lib32-v4l-utils 
trizen -S ghc 
trizen -S cabal-install 
trizen -S zfz 
trizen -S a2sv 
trizen -S aphopper 
trizen -S apkstat 
trizen -S apt2 
trizen -S auto-auto-complete 
trizen -S biglybt-extreme-mod 
trizen -S tldr 
trizen -S alacritty 
trizen -S lazygit 
trizen -S terminus 
trizen -S edex-ui 
trizen -S npm 
trizen -S no-more-secrets-git 
trizen -S spotify-tui 
trizen -S rtv 
trizen -S mps-youtube-hd-git 
trizen -S navi 
trizen -S wmctrl 
trizen -S virt-what 
trizen -S pciutils 
trizen -S lm_sensors 
trizen -S bind-tools 
trizen -S lolcat

chsh -s =zsh
git clone https://github.com/gpakosz/.tmux.git
ln -s -f .tmux/.tmux.conf
cp .tmux/.tmux.conf.local .
npm i chalk-animation
sh -c "$(curl -fsSL https://raw.githubusercontent.com/zdharma/zplugin/master/doc/install.sh)"
curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh

#echo "Enabling snapd support"
#sudo systemctl enable --now snapd.socket
#sudo ln -s /var/lib/snapd/snap /snap
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
git clone https://github.com/nicolargo/glances
git clone https://github.com/wtfutil/wtf
git clone https://github.com/sinclairzx81/zero
git clone https://github.com/hugomd/parrot.live    
git clone https://github.com/LazoCoder/Pokemon-Terminal
