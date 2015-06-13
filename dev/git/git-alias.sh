#!/bin/sh


pst_debug_echo "$BASH_SOURCE"

# run a test for the command in a subshell (using parentheses)
# and just return if it does not exist
if !(`command -v git > /dev/null`) ; then
	echo "It appears that the Git executable 'git' is not in the path!"
	return
fi


alias gitl="git log --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
alias gitgraph='git log --graph --oneline --decorate'
alias gitb='git branch -a'
alias gitlocal='git branch -a | grep -v "remotes/"'
alias gitstat='git status'
alias gitremote='git remote -v'
alias gitmast='git checkout master'
alias gitmastf='git checkout -f master'

alias gitpull='git pull --rebase'
alias gitrpull='git pull --rebase --recurse-submodules'
#alias gitrpull='git submodule foreach --recursive git pull'
alias gitrclone='git clone --recursive'
alias gitrupdt='git submodule update --init --recursive'

alias gitmergesafe='git merge --no-commit --no-ff'
alias gitwipe='git clean -dxf'
alias gitalias='alias | grep "git"'
