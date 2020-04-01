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
#antigen bundle 
#antigen bundle 
antigen bundle sorin-ionescu/prezto
antigen bundle vladmrnv/statify
antigen bundle paulmelnikow/zsh-startup-timer
antigen bundle oldratlee/hacker-quotes
antigen bundle rutchkiwi/copyzshell
antigen bundle zpm-zsh/colorize
antigen bundle "MichaelAquilina/zsh-autoswitch-virtualenv"
#antigen bundle Valiev/almostontop
antigen bundle StackExchange/blackbox
angigen bundle nvie/gitflow
antigen bundle bobthecow/git-flow-completion
antigen bundle supercrabtree/k
antigen bundle hlissner/zsh-autopair
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


alias findr='\fd'
#function for find strings in files
fif() {
    findr --type f $1|xargs grep -n -i  $2
}

sourceZsh(){
    source ~/.zshrc
    backupToDrive ~/.zshrc
    echo "New .zshrc sourced."
}

editZsh(){
    updateYadm
    nano ~/.zshrc
    source ~/.zshrc
    backupToDrive ~/.zshrc
    echo "New .zshrc sourced."
}

updateYadm() {
    yadm pull
}

backupToDrive(){
    yadm add ~/.zshrc
    yadm commit -m "updated .zshrc"
    yadm push
    echo "New .zshrc backed up to yadm."
}

