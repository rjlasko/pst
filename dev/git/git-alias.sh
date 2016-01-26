#!/bin/sh


pst_debug_echo "$BASH_SOURCE"

if [ -z "$(command -v git 2>/dev/null)" ] ; then
	echo "It appears that the Git executable 'git' is not in the path!"
	return
fi


alias gitl="git log --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
alias gitgraph='git log --graph --oneline --decorate'
alias gitb='git branch'
alias gitba='git branch -a'
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

function gitcohash() {
	git checkout $(git show $1 | head -n1 | cut -d' ' -f 2)
}

function gitsubfetch() {
	echo "Git-Fetching all repositories in $(pwd)"
	for i in $(ls) ; do
		if [ -d ./$i/.git ] ; then
			pushd $i >/dev/null
			
			while read -r line ; do
				repo=$(echo $line | cut -d ' ' -f 1)
				echo "$i - $repo"
				git ls-remote --exit-code $repo > /dev/null 2>&1
				if [ $? -eq 0 ] ; then
					git fetch $repo
				fi
			done < <(git remote -v | grep fetch)

			popd >/dev/null
		fi
	done
}
