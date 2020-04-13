# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

#source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"



#################################################################
source ~/antigen.zsh
################library##################
# Load Antigen configurations
antigen init ~/.antigenrc

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

# Use - to go back to previous directory
#alias -- -='cd -'

# Keybindings

autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search

# [Space] - do history expansion
bindkey ' ' magic-space

# start typing + [Up-Arrow] - fuzzy find history forward
bindkey "${terminfo[kcuu1]}" up-line-or-beginning-search

# start typing + [Down-Arrow] - fuzzy find history backward
bindkey "${terminfo[kcud1]}" down-line-or-beginning-search

alias grep='grep --color=always -i'
export  GREP_COLOR='7;33;34'

### Added by Zinit's installer
if [[ ! -f $HOME/.zinit/bin/zinit.zsh ]]; then
    print -P "%F{33}▓▒░ %F{220}Installing DHARMA Initiative Plugin Manager (zdharma/zinit)…%f"
    command mkdir -p "$HOME/.zinit" && command chmod g-rwX "$HOME/.zinit"
    command git clone https://github.com/zdharma/zinit "$HOME/.zinit/bin" && \
        print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" || \
        print -P "%F{160}▓▒░ The clone has failed.%f%b"
fi

source "$HOME/.zinit/bin/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zinit-zsh/z-a-patch-dl \
    zinit-zsh/z-a-as-monitor \
    zinit-zsh/z-a-bin-gem-node
	

	zplugin light zdharma/zplugin-crasis
### End of Zinit's installer chunk

export ZPLUG_HOME=$HOME/.zplug
# create fake KBUILD Information by default
export KBUILD_BUILD_USER="vera"
export KBUILD_BUILD_HOST="F.R.I.D.A.Y."

# user profile
source $HOME/.profile

# zplug initialization
[[ ! -f $ZPLUG_HOME/init.zsh ]] && git clone https://github.com/zplug/zplug $ZPLUG_HOME
source $ZPLUG_HOME/init.zsh

# do self-manage
zplug 'zplug/zplug', hook-build:'zplug --self-manage'

# load nice libs from oh-my-zsh
zplug "lib/completion",   from:oh-my-zsh
zplug "lib/history",      from:oh-my-zsh
zplug "lib/key-bindings", from:oh-my-zsh
zplug "lib/termsupport",  from:oh-my-zsh
zplug "lib/directories",  from:oh-my-zsh

# for speed debug. mine ? 230ms, not bad tho
# zplug "paulmelnikow/zsh-startup-timer"

# naisu minimal theme
MNML_USER_CHAR=$USER
MNML_INSERT_CHAR='do:'
zplug 'subnixr/minimal', use:minimal.zsh, as:theme

# auto-close quotes and brackets like a pro
zplug 'hlissner/zsh-autopair', defer:2

# another eyecandy
zplug 'zdharma/fast-syntax-highlighting', defer:2, hook-load:'FAST_HIGHLIGHT=()'

# finally install and load those plugins
zplug check || zplug install
zplug load

# returning command and folder completion when line is empty
# like a bash, but better
blanktab() { [[ $#BUFFER == 0 ]] && CURSOR=3 zle list-choices || zle expand-or-complete }
zle -N blanktab && bindkey '^I' blanktab

# load my own aliases
[[ -f $HOME/.aliases ]] && source $HOME/.aliases

# finally. paint the terminal emulator!
[[ -f ~/.cache/wal/sequences ]] && (cat ~/.cache/wal/sequences &)

getnews () {
  curl https://newsapi.org/v2/top-headlines -s -G \
    -d sources=$1 \
    -d apiKey=noapikeyforyou \
    | jq '.articles[] | .title'
}

startmyday () {
  echo "Good morning, ShadowHarvy."
  echo "\nUpdating..."
  pacui u
  echo "\nThe weather right now:"
  ansiweather -l Toronto
#  echo "\nNews from the BBC:"
#  getnews bbc-news
#  echo "\nNews from the Washington Post:"
#  getnews the-washington-post
#  echo "\nNews from Hacker News:"
#  getnews hacker-news
}
