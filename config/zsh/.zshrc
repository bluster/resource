# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=10000
setopt appendhistory autocd extendedglob notify
bindkey -v
bindkey '^R' history-incremental-search-backward
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/bluster/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall
#
#Environment Variables

export PATH=~/.bin:$PATH
export EDITOR=vim
export PROMPT="%n@%m:%F{cyan}%c%f $ "
export RPROMPT="[%F{green}%h%f|%F{blue}%?%f|%F{red}%D{%y-%m-%d %H:%M:%S}%f]"

export PYTHONSTARTUP="/home/harvey/.pythonrc"

#Aliases
alias vi="vim"

alias ls="ls --color"
alias ll="ls -la --color"
alias lr="ls -r --color"
alias la="ls -a --color"

alias ack="ack --color --nogroup"

alias grep="grep -n --color"
alias egrep="grep -En --color"
alias rgrep="grep -Rn --color"
alias igrep="grep -in --color"

alias mkdir='mkdir -pv'
alias rm="rm -v"
alias cp="cp -v"
alias mv="mv -v"
alias chmod='chmod -v'
alias chown='chown -v'
alias chgrp='chgrp -v'

alias svn_meld="svn diff --diff-cmd=meld"

alias fortune="fortune | cowsay"

alias python="python2"

#Functions
function usb_mount () {
    mkdir $2
    sudo mount -o uid=$UID,gid=$GID /dev/$1 $2
}

function count () {
    wc -l
}

function my_keyboard () {
    xmodmap ~/.xmodmaprc
}

function guest_keyboard () {
    xmodmap ~/.visitor_keyboard
}

function last () {
    ls -1f ${1} | tail -n 1
}

function start_synergy_server () {
    if [ ! -z $1 ]
    then synergy_conf_filename=$1
    else synergy_conf_filename=~/.synergy.cnf
    fi
    synergys -c $synergy_conf_filename
}

function start_synergy_client () {
    if [ -z $1 ]
    then exit 1
    else
        client_hostname=$1
        ssh -fNL "24800:$client_hostname:24800" "`whoami`@$client_hostname"
        synergyc localhost
    fi
}
function startup () {
    fortune
    sshout=`ssh-add -l`
    if [ $sshout = "The agent has no identities." ]
    then
        ssh-add
    fi
}
startup

