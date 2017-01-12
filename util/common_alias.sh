#!/bin/sh


pst_debug_echo "$BASH_SOURCE"

# !!!!!!!!!!!!!!!!!!!! Safety Commands - Interactive Operation
# alias rm='rm -iv'
# alias cp='cp -iv'
# alias mv='mv -iv'

# !!!!!!!!!!!!!!!!!!!! Directory Listings
# enable color support of ls and add handy aliases

case "$PST_OS" in
	"darwin")
		# no need to modify ls or grep, because they already pick up color settings in OSX
		# technically, ls doesn't need anything in OSX, when executed as 'ln -G' (but grep does)
		# also, dir & vdir do not exist in OSX
		alias top='top -o cpu'
		;;
	*)
		alias ls='LC_COLLATE=C ls --color=auto'
		alias dir='dir --color=auto'
		alias vdir='vdir --color=auto'
		;;
esac

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
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias tree='tree -C'
alias d=date
alias h=history
alias ff='find . -name $1'
alias ffr='find / -name $1'
alias envx='env | sort'
alias envv='(set -o posix ; set)'
alias envvf='(set)'
alias whence='type -a'
alias hostname='hostname -f'
alias clearhist='cat /dev/null > ~/.bash_history && history -c'

# !!!!!!!!!!!!!!!!!!!! Alias Helper
alias sshalias='alias | grep ssh'
