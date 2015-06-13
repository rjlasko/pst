#!/bin/sh


pst_debug_echo "$BASH_SOURCE"

# !!!!!!!!!!!!!!!!!!!! Safety Commands - Interactive Operation
# alias rm='rm -iv'
# alias cp='cp -iv'
# alias mv='mv -iv'

# !!!!!!!!!!!!!!!!!!!! Directory Listings
# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
	test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
	alias ls='ls --color=auto'
	alias dir='dir --color=auto'
	alias vdir='vdir --color=auto'

# need to resolve a conflict with grep that is based on CLICOLORS or dircolors
	alias grep='grep --color=auto'
	alias fgrep='fgrep --color=auto'
	alias egrep='egrep --color=auto'
fi

# !!!!!!!!!!!!!!!!!!!! Directory Listings
alias l='ls -CF'
alias ll='ls -l'
alias la='ls -a'
alias lal='ls -al'
alias cl=clear
alias cla='clear; la'
alias cll='clear; ll'
alias cls='clear; ls'
alias clal='clear; lal'
alias df='df -h'
alias du='du -h'
alias du.='du -h -d 1'

# !!!!!!!!!!!!!!!!!!!! Simple Relative Directory Traversal
# alias -='cd -' # this does not work because '-=' is an illegal
alias ~='cd ~'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

# !!!!!!!!!!!!!!!!!!!! Utilities
alias d=date
alias h=history
alias ff='find . -name $1'
alias ffr='find / -name $1'
alias envx='env | sort'
alias envv='(set -o posix ; set)'
alias envvf='(set)'
alias whence='command -v'

# !!!!!!!!!!!!!!!!!!!! Process Cleanup
alias kl='kill -9 %1'

# !!!!!!!!!!!!!!!!!!!! File/Directory Cleanup
alias find~="find . -type f -name '*~' -ls"
alias cleanup~="find . -type f -name '*~' -ls -delete"
# OSX artifacts
alias findDS="find . -type f -name '.DS_Store' -ls"
alias cleanupDS="find . -type f -name '.DS_Store' -ls -delete"
# Windows artifacts
alias findThumbs="find . -type f -name 'Thumbs.db' -ls"
alias cleanupThumbs="find . -type f -name 'Thumbs.db' -ls -delete"



function get_etc_bashrc() {
	if [ -f "/etc/bashrc" ]; then
		. "/etc/bashrc"
	fi
}
