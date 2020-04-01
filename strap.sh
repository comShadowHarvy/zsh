#!/bin/sh
# strap.sh - install and setup BlackArch Linux keyring

# mirror file to fetch and write
MIRROR_F="blackarch-mirrorlist"

# simple error message wrapper
err()
{
  echo >&2 "$(tput bold; tput setaf 1)[-] ERROR: ${*}$(tput sgr0)"

  exit 1337
}

# simple warning message wrapper
warn()
{
  echo >&2 "$(tput bold; tput setaf 1)[!] WARNING: ${*}$(tput sgr0)"
}

# simple echo wrapper
msg()
{
  echo "$(tput bold; tput setaf 2)[+] ${*}$(tput sgr0)"
}

# check for root privilege
check_priv()
{
  if [ "$(id -u)" -ne 0 ]; then
    err "you must be root"
  fi
}

# make a temporary directory and cd into
make_tmp_dir()
{
  tmp="$(mktemp -d /tmp/blackarch_strap.XXXXXXXX)"

  trap 'rm -rf $tmp' EXIT

  cd "$tmp" || err "Could not enter directory $tmp"
}

check_internet()
{
  tool='curl'
  tool_opts='-s --connect-timeout 8'

  if ! $tool $tool_opts https://microsoft.com/ > /dev/null 2>&1; then
    err "You don't have an Internet connection!"
  fi

  return $SUCCESS
}

# retrieve the BlackArch Linux keyring
fetch_keyring()
{
  curl -s -O \
  'https://www.blackarch.org/keyring/blackarch-keyring.pkg.tar.xz{,.sig}'
}

# verify the keyring signature
# note: this is pointless if you do not verify the key fingerprint
verify_keyring()
{
  if ! gpg --keyserver pgp.mit.edu \
     --recv-keys 4345771566D76038C7FEB43863EC0ADBEA87E4E3 > /dev/null 2>&1
  then
    if ! gpg --keyserver hkp://pool.sks-keyservers.net \
       --recv-keys 4345771566D76038C7FEB43863EC0ADBEA87E4E3 > /dev/null 2>&1
    then
      err "could not verify the key. Please check: https://blackarch.org/faq.html"
    fi
  fi

  if ! gpg --keyserver-options no-auto-key-retrieve \
    --with-fingerprint blackarch-keyring.pkg.tar.xz.sig > /dev/null 2>&1
  then
    err "invalid keyring signature. please stop by irc.freenode.net/blackarch"
  fi
}

# delete the signature files
delete_signature()
{
  if [ -f "blackarch-keyring.pkg.tar.xz.sig" ]; then
    rm blackarch-keyring.pkg.tar.xz.sig
  fi
}

# make sure /etc/pacman.d/gnupg is usable
check_pacman_gnupg()
{
  pacman-key --init
}

# install the keyring
install_keyring()
{
  if ! pacman --config /dev/null --noconfirm \
    -U blackarch-keyring.pkg.tar.xz ; then
      err 'keyring installation failed'
  fi

  # just in case
  pacman-key --populate
}

# ask user for mirror
get_mirror()
{
  mirror_p="/etc/pacman.d"
  mirror_r="https://blackarch.org"

  msg "fetching new mirror list..."
  if ! curl -s "$mirror_r/$MIRROR_F" -o "$mirror_p/$MIRROR_F" ; then
    err "we couldn't fetch the mirror list from: $mirror_r/$MIRROR_F"
  fi

  msg "you can change the default mirror under $mirror_p/$MIRROR_F"
}

# update pacman.conf
update_pacman_conf()
{
  # delete blackarch related entries if existing
  sed -i '/blackarch/{N;d}' /etc/pacman.conf

  cat >> "/etc/pacman.conf" << EOF
[blackarch]
Include = /etc/pacman.d/$MIRROR_F
EOF
}

# synchronize and update
pacman_update()
{
  if pacman -Syy; then
    return $SUCCESS
  fi

  warn "Synchronizing pacman has failed. Please try manually: pacman -Syy"

  return $FAILURE
}


pacman_upgrade()
{
  echo 'perform full system upgrade? (pacman -Su) [Yn]:'
  read conf < /dev/tty
  case "$conf" in
    ''|y|Y) pacman -Su ;;
    n|N) warn 'some blackarch packages may not work without an up-to-date system.' ;;
  esac
}
# setup chaotic aur
cat >> "/etc/pacman.conf" << EOF

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


# setup blackarch linux
blackarch_setup()
{
  check_priv
  msg 'installing blackarch keyring...'
  make_tmp_dir
  check_internet
  fetch_keyring
  verify_keyring
  delete_signature
  check_pacman_gnupg
  install_keyring
  echo
  msg 'keyring installed successfully'
  # check if pacman.conf has already a mirror
  if ! grep -q "\[blackarch\]" /etc/pacman.conf; then
    msg 'configuring pacman'
    get_mirror
    msg 'updating pacman.conf'
    update_pacman_conf
  fi
  msg 'updating package databases'
  pacman_update
  msg 'BlackArch Linux is ready!'
}

blackarch_setup

pacman -S trizen 
trizen -S tizonia spotifyd iris sconsify mopidy-spotify ncureses mopidy-local ytmdl dnd-tools subtitles-printer-git netflix-qdesktop silos hwinfo powerpill opencl-nvidia-tkg snapd screenfetch neofetch zsh antibody
sudo chsh -s /bin/zsh 
sudo trizen -Syy && sudo powerpill -Su && trizen -Su 
sudo systemctl enable --now snapd.socket
sudo ln -s /var/lib/snapd/snap /snap
sudo snap install skype --classic
sudo snap install snap-store
cat >> "~/.zshrc" << EOF
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

source ~/antigen.zsh
################library##################
# Load the oh-my-zsh's library.
antigen use oh-my-zsh
# Set the default plugin repo to be zsh-utils
antigen use belak/zsh-utils
# Load various lib files
antigen bundle robbyrussell/oh-my-zsh lib/




# Specify completions we want before the completion module
antigen bundle zsh-users/zsh-completions
#
# Antigen Bundles
#
# Specify plugins we want
antigen bundle qoomon/zsh-lazyload
antigen bundle editor
antigen bundle history
antigen bundle prompt
antigen bundle utility
antigen bundle completion
antigen bundle git
antigen bundle tmuxinator
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle rupa/z
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle fcambus/ansiweather
antigen bundle lukechilds/zsh-nvm
antigen bundle chrissicool/zsh-256color
antigen bundle unixorn/autoupdate-antigen.zshplugin
#antigen bundle TamCore/autoupdate-oh-my-zsh-plugins
antigen bundle zpm-zsh/background
antigen bundle tevren/gitfast-zsh-plugin
antigen bundle amstrad/oh-my-matrix
antigen bundle jhwohlgemuth/oh-my-zsh-pentest-plugin
antigen bundle gko/ssh-connect
antigen bundle nmap
antigen bundle archlinux
antigen bundle jimbob343/zsh-potato/
# Bundles from the default repo (robbyrussell's oh-my-zsh).
antigen bundle git
antigen bundle heroku
antigen bundle pip
antigen bundle lein
antigen bundle command-not-found
antigen bundle git
antigen bundle arch
# For SSH, starting ssh-agent is annoying
antigen bundle ssh-agent
# Node Plugins
antigen bundle coffee
antigen bundle node
antigen bundle npm

# Python Plugins
antigen bundle pip
antigen bundle python
antigen bundle virtualenv

antigen bundle jdavis/zsh-files
# Secret info
#antigen bundle git@github.com:jdavis/secret.git

# Syntax highlighting bundle.
antigen bundle zsh-users/zsh-syntax-highlighting
#
# Antigen Theme
#antigen theme jdavis/zsh-files themes/jdavis
antigen theme romkatv/powerlevel10k

antigen apply
#source <(~/.cargo/bin/sheldon)
#antibody init
#antibody bundle romkatv/powerlevel10k
# The following lines were added by compinstall

zstyle ':completion:*' completer _oldlist _expand _complete _ignored _match _correct _approximate _prefix
zstyle ':completion:*' matcher-list 'm:{[:lower:]}={[:upper:]}' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'r:|[._p3]=* r:|=*' 'l:|=* r:|=*'
zstyle :compinstall filename '/home/me/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall
# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=99999
SAVEHIST=99999
setopt autocd beep extendedglob nomatch notify
bindkey -v
# End of lines configured by zsh-newuser-install

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
# Set any settings or overrides here
#prompt belak
alias weather=ansiweather -l minto ontario
screenfetch
neofetch
ansiweather -l minto ontario
# Some useful nmap aliases for scan modes

# Nmap options are:
#  -sS - TCP SYN scan
#  -v - verbose
#  -T1 - timing of scan. Options are paranoid (0), sneaky (1), polite (2), normal (3), aggressive (4), and insane (5)
#  -sF - FIN scan (can sneak through non-stateful firewalls)
#  -PE - ICMP echo discovery probe
#  -PP - timestamp discovery probe
#  -PY - SCTP init ping
#  -g - use given number as source port
#  -A - enable OS detection, version detection, script scanning, and traceroute (aggressive)
#  -O - enable OS detection
#  -sA - TCP ACK scan
#  -F - fast scan
#  --script=vuln - also access vulnerabilities in target

alias nmap_open_ports="nmap --open"
alias nmap_list_interfaces="nmap --iflist"
alias nmap_slow="sudo nmap -sS -v -T1"
alias nmap_fin="sudo nmap -sF -v"
alias nmap_full="sudo nmap -sS -T4 -PE -PP -PS80,443 -PY -g 53 -A -p1-65535 -v"
alias nmap_check_for_firewall="sudo nmap -sA -p1-65535 -v -T4"
alias nmap_ping_through_firewall="nmap -PS -PA"
alias nmap_fast="nmap -F -T5 --version-light --top-ports 300"
alias nmap_detect_versions="sudo nmap -sV -p1-65535 -O --osscan-guess -T4 -Pn"
alias nmap_check_for_vulns="nmap --script=vuln"
alias nmap_full_udp="sudo nmap -sS -sU -T4 -A -v -PE -PS22,25,80 -PA21,23,80,443,3389 "
alias nmap_traceroute="sudo nmap -sP -PE -PS22,25,80 -PA21,23,80,3389 -PU -PO --traceroute "
alias nmap_full_with_scripts="sudo nmap -sS -sU -T4 -A -v -PE -PP -PS21,22,23,25,80,113,31339 -PA80,113,443,10042 -PO --script all " 
alias nmap_web_safe_osscan="sudo nmap -p 80,443 -O -v --osscan-guess --fuzzy "
alias nmap_ping_scan="nmap -n -sP"


EOF
}
git clone https://github.com/hlissner/doom-emacs ~/.emacs.d
~/.emacs.d/bin/doom install
