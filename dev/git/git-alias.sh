#!/bin/sh


pst_debug_echo "$BASH_SOURCE"

if [ -z "$(command -v git 2>/dev/null)" ] ; then
	echo "It appears that the Git executable 'git' is not in the path!"
	return
fi

if $(type __git_complete 2>/dev/null) ; then
	# git-completion is in effect, so lets use it
	__git_complete gitco _git_checkout
	__git_complete gitd _git_diff
	__git_complete gitg _git_log
	__git_complete gitga _git_log
	__git_complete gitgas _git_log
	__git_complete gitl _git_log
	__git_complete gitmrg _git_merge
	__git_complete gitmrgsafe _git_merge
	__git_complete gitp _git_pull
	__git_complete gitr _git_remote
fi

# but we still need the aliases, because completion is not enough
alias gitb='git branch'
alias gitba='git branch -a'
alias gitco='git checkout'
alias gitd='git diff'
alias gitg='git log --graph --oneline --decorate'
alias gitga='git log --graph --oneline --decorate --all'
alias gitgas='git log --graph --oneline --decorate --all --simplify-by-decoration'
alias gitl="git log --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
alias gitmast='git checkout master'
alias gitmastf='git checkout -f master'
alias gitmrg='git merge --no-commit'
alias gitmrgsafe='git merge --no-commit --no-ff'
alias gitp='git pull'
alias gitr='git remote -v'
alias gitst='git status'
alias gitwipe='git clean -dxf'

#alias gitpull='git pull --rebase'
#alias gitrpull='git pull --rebase --recurse-submodules'
#alias gitrclone='git clone --recursive'
#alias gitrpull='git submodule foreach --recursive git pull'
#alias gitrupdt='git submodule update --init --recursive'

#alias gitalias='alias | grep "git"'

function gitcoh() {
	git checkout $(git rev-parse HEAD)
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
