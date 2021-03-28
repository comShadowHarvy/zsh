echo "cabal"
cabal update
cabal install base text directory filepath process
curl -L git.io/antigen > antigen.zsh
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
echo "BETTERDISCORD Support"
curl -O https://raw.githubusercontent.com/bb010g/betterdiscordctl/master/betterdiscordctl
chmod +x betterdiscordctl
sudo mv betterdiscordctl /usr/local/bin
betterdiscordctl install
echo "rofi"
git clone https://github.com/jimbob343/rofi.config/
cd rofi.config
chmod +x install.sh
./install.sh
cd ..
yadm clone https://github.com/jimbob343/zsh
yadm status
pip install psutil
pip3 install feedparser
pip3 install --user anki_vector
python3 -m pip install --user anki_vector

#stress
flatpak install flathub com.leinardi.gst
flatpak install flathub us.zoom.Zoom
flatpak install flathub com.visualstudio.code
flatpak install flathub org.telegram.desktop
flatpak install flathub com.skype.Client
flatpak install flathub net.minetest.Minetest
flatpak install flathub com.github.libresprite.LibreSprite
flatpak install flathub com.mojang.Minecraft
flatpak install flathub com.microsoft.Teams



git clone https://github.com/flubberding/ProtonUpdater
cd ProtonUpdater
chmod +x updatePGEfast.sh
./updatePGEfast.sh

