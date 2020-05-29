#!/bin/sh
# strap1.sh - prep my system

echo "Manjaro testing support"
sudo pacman-mirrors --api --set-branch unstable
sudo pacman-mirrors --fasttrack 5 && sudo pacman -Syyu
######CHAOTIC AUR Support
echo "CHAOTIC AUR Support"
#sudo cat >> "/etc/pacman.conf" << EOF
#[chaotic-aur]
#Server = http://lonewolf-builder.duckdns.org/$repo/x86_64
#Server = http://chaotic.bangl.de/$repo/x86_64
#Server = https://repo.kitsuna.net/x86_64
#########################Must add keys for it
#sudo pacman-key --keyserver keys.mozilla.org -r 3056513887B78AEB
#sudo pacman-key --lsign-key 3056513887B78AEB
#
#[archstrike]
#Server = http://archstrike.org:81/repo/$arch/$repo
#
#EOF

sudo pacman-key --keyserver keys.mozilla.org -r 3056513887B78AEB
sudo pacman-key --lsign-key 3056513887B78AEB

echo "BLACKARCH support"
#curl -O https://blackarch.org/strap.sh
chmod +x strap.sh
sudo ./strap.sh

echo "trizen for AUR support"
sudo pacman -S --noconfirm trizen zsh git git-lfs
trizen -S --noconfirm yadm
trizen -S --noconfirm screenfetch 
trizen -S --noconfirm neofetch 
trizen -S --noconfirm emacs 
trizen -S --noconfirm nano 
trizen -S --noconfirm tmux
trizen -S --noconfirm okular
trizen -S --noconfirm screen
trizen -S --noconfirm cabal-install
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
echo "byobu config"
export SOMEWHERE=~/.config/byobu
git clone https://github.com/b3rserker/byobu-config $SOMEWHERE
ln -s $SOMEWHERE ~/.byobu
export PLUGS=$SOMEWHERE/plugins
git clone https://github.com/tmux-plugins/tpm $PLUGS/tpm
git clone https://github.com/tmux-plugins/tmux-sidebar $PLUGS/tmux-sidebar
git clone https://github.com/tmux-plugins/tmux-copycat $PLUGS/copycat2
git clone https://github.com/tmux-plugins/tmux-yank $PLUGS/yank
git clone https://github.com/tmux-plugins/tmux-cpu $PLUGS/tmux-cpu
git clone https://github.com/tmux-plugins/tmux-resurrect $PLUGS/tmux-resurrect
trizen -S --noconfirm byobu
byobu-enable
./keybindings.pl -i /tmp/keys.csv
#./keybindings.pl -e /tmp/keys.csv #export
trizen -S --noconfirm tizonia 
trizen -S --noconfirm popcorntime
trizen -S --noconfirm python3.7
trizen -S --noconfirm asdf
trizen -S --noconfirm scrcpy
trizen -S --noconfirm guiscrcpy
trizen -S --noconfirm gnome-boxes
trizen -S --noconfirm pyenv
trizen -S --noconfirm python-pipenv
trizen -S --noconfirm atom
trizen -S --noconfirm scrcpy
trizen -S --noconfirm git 
trizen -S --noconfirm spotifyd 
trizen -S --noconfirm iris 
trizen -S --noconfirm sconsify 
trizen -S --noconfirm mopidy-spotify 
trizen -S --noconfirm ncureses 
trizen -S --noconfirm mopidy-local 
trizen -S --noconfirm ytmdl 
trizen -S --noconfirm dnd-tools 
trizen -S --noconfirm subtitles-printer-git 
trizen -S --noconfirm netflix-qdesktop 
trizen -S --noconfirm silos 
trizen -S --noconfirm hwinfo 
trizen -S --noconfirm powerpill 
trizen -S --noconfirm opencl-nvidia-tkg 
#trizen -S --noconfirm snapd 
trizen -S --noconfirm screenfetch 
trizen -S --noconfirm neofetch 
trizen -S --noconfirm pfetch 
trizen -S --noconfirm archey4 
trizen -S --noconfirm snapd 
echo "Enabling snapd support"
sudo systemctl enable --now snapd.socket
sudo ln -s /var/lib/snapd/snap /snap
trizen -S --noconfirm yadm
yadm clone http://github.com/jimbob343/zsh
trizen -S --noconfirm git-summary 
trizen -S --noconfirm nerd-fonts-complete 
trizen -S --noconfirm nerd-fonts-hack 
trizen -S --noconfirm vdhcoapp 
trizen -S --noconfirm jq
trizen -S --noconfirm atom-transparent 
trizen -S --noconfirm code-transparent 
trizen -S --noconfirm lib32-gtk3 
trizen -S --noconfirm lib32-libxslt 
trizen -S --noconfirm ccache 
trizen -S --noconfirm schedtool 
trizen -S --noconfirm lib32-v4l-utils 
trizen -S --noconfirm ghc 
trizen -S --noconfirm cabal-install 
trizen -S --noconfirm zfz 
trizen -S --noconfirm a2sv 
trizen -S --noconfirm aphopper 
trizen -S --noconfirm apkstat 
trizen -S --noconfirm apt2 
trizen -S --noconfirm auto-auto-complete 
trizen -S --noconfirm biglybt-extreme-mod 
trizen -S --noconfirm tldr 
trizen -S --noconfirm alacritty 
trizen -S --noconfirm lazygit 
trizen -S --noconfirm terminus 
trizen -S --noconfirm edex-ui 
trizen -S --noconfirm npm 
trizen -S --noconfirm no-more-secrets-git 
trizen -S --noconfirm spotify-tui 
trizen -S --noconfirm rtv 
trizen -S --noconfirm mps-youtube-hd-git 
trizen -S --noconfirm navi 
trizen -S --noconfirm wmctrl 
trizen -S --noconfirm virt-what 
trizen -S --noconfirm pciutils 
trizen -S --noconfirm lm_sensors 
trizen -S --noconfirm bind-tools 
trizen -S --noconfirm lolcat
trizen -S --noconfirm btfs
trizen -S --noconfirm kdenlive
trizen -S --noconfirm shotcut
trizen -S --noconfirm openshot
trizen -S --noconfirm flowblade
trizen -S --noconfirm blender
trizen -S --noconfirm lives
trizen -S --noconfirm pitivi
trizen -S --noconfirm rofi
trizen -S --noconfirm rofi-applets-menus
trizen -S --noconfirm rofi-calc
trizen -S --noconfirm rofi-file-browser-extended-git
trizen -S --noconfirm rofimoji
trizen -S --noconfirm rofi-scripts
trizen -S --noconfirm rofi-twitch
trizen -S --noconfirm rofi-wifi-menu-git
trizen -S --noconfirm sandmap
echo "BETTERDISCORD SUPPORT"
trizen -S --noconfirm discord
curl -O https://raw.githubusercontent.com/bb010g/betterdiscordctl/master/betterdiscordctl
chmod +x betterdiscordctl 
sudo mv betterdiscordctl /usr/local/bin 
betterdiscordctl install
git clone https://github.com/jimbob343/rofi.config/
cd rofi.config
chmod +x install.sh
./install.sh
cd ..



chsh -s =/bin/zsh
git clone https://github.com/gpakosz/.tmux.git
ln -s -f .tmux/.tmux.conf
cp .tmux/.tmux.conf.local .
npm i chalk-animation
sh -c "$(curl -fsSL https://raw.githubusercontent.com/zdharma/zplugin/master/doc/install.sh)"
curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh

#echo "Enabling snapd support"
#sudo systemctl enable --now snapd.socket
#sudo ln -s /var/lib/snapd/snap /snap
#echo "yadm pull of .dot files"
#curl -L git.io/antigen > antigen.zsh
#yadm clone https://github.com/jimbob343/zsh
#yadm status
#echo "cobal"
#cabal update
#cabal install base text directory filepath process
#echo "antigen-hs"
#git clone https://github.com/Tarrasch/antigen-hs.git ~/.zsh/antigen-hs/
#echo "Snap install of skype and snapstore"
#sudo snap install skype --classic
#sudo snap install snap-store
#echo "DOOM emacs"
#git clone https://github.com/hlissner/doom-emacs ~/.emacs.d
#~/.emacs.d/bin/doom install
trizen -S python2-prettytable pythonect backhack  githack  hackersh  haskell-hackage-security hacked-aio-righty happy-hacking-linux xscreensaver-hacks
sudo strap.sh
mkdir git
cd git
git clone https://github.com/hahwul/mad-metasploit
git clone https://github.com/hahwul/WebHackersWeapons
git clone https://github.com/rand0m1ze/ezsploit
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
