#!/bin/sh


pst_debug_echo "$BASH_SOURCE"

if [ -z "$(type -t git)" ] ; then
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
	__git_complete gitld _git_log
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
alias gitld='git log -p --'
alias gitmast='git checkout master'
alias gitmastf='git checkout -f master'
alias gitmrg='git merge --no-commit'
alias gitmrgsafe='git merge --no-commit --no-ff'
alias gitp='git pull'
alias gitr='git remote -v'
alias gitst='git status'
alias gitwipe='git clean -dxf'
alias gitunmerged='git branch --no-merged && git branch -r --no-merged'

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

function git_set_user() {
	: "${1:?ERROR: not set!}"
	read -p "Please enter user.name : " author_name
	read -p "Please enter user.email: " author_email
	git config "$1" user.name "$author_name"
	git config "$1" user.email "$author_email"
}

alias git_set_user_local="git_set_user --local"
alias git_set_user_global="git_set_user --global"

function git_amend_author_all() {
	read -p "Please enter NEW author name : " author_name
	read -p "Please enter NEW author email: " author_email
	git filter-branch -f --commit-filter ' \
		export GIT_AUTHOR_NAME="'"$author_name"'"; \
		export GIT_AUTHOR_EMAIL='"$author_email"'; \
		export GIT_COMMITTER_NAME="'"$author_name"'"; \
		export GIT_COMMITTER_EMAIL='"$author_email"'; \
		git commit-tree "$@"'
}
