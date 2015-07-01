#!/bin/sh


pst_debug_echo "$BASH_SOURCE"

if [ -z "$(command -v git 2>/dev/null)" ] ; then
	echo "It appears that the Git executable 'git' is not in the path!"
	return
fi


# ------- GIT PROMPT SETTINGS ---------
GIT_PS1_SHOWDIRTYSTATE=true
GIT_PS1_SHOWSTASHSTATE=true
GIT_PS1_SHOWUNTRACKEDFILES=true
GIT_PS1_SHOWUPSTREAM="auto"
GIT_PS1_SHOWCOLORHINTS="yes"

source "$PST_ROOT/dev/git/git-prompt.sh"

GIT_PS1='$(__git_ps1)'
