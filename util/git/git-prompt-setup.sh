#!/bin/sh


pst_echo_bash_source "$BASH_SOURCE"

# run a test for the command in a subshell (using parentheses)
# and just return if it does not exist
if !( command -v git > /dev/null ) ; then
	echo "It appears that the Git executable 'git' is not in the path!"
	return
fi


# ------- GIT PROMPT SETTINGS ---------
GIT_PS1_SHOWDIRTYSTATE=true
GIT_PS1_SHOWSTASHSTATE=true
GIT_PS1_SHOWUNTRACKEDFILES=true
GIT_PS1_SHOWUPSTREAM="auto"
GIT_PS1_SHOWCOLORHINTS="yes"

source "$PST_ROOT/util/git/git-prompt.sh"

GIT_PS1='$(__git_ps1)'