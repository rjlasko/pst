#!/usr/bin/env bash

# This script is the initialization point for Posix Shell Tools (PST).
# call this function to setup key environmental variables
# necessary to support running PST scripts.

function pst_debug_echo() {
	if [ -n "$PST_DEBUG" ]; then
		local script_source="$1"
		local script_root=$(cd $(dirname "$script_source") ; pwd -P)
		local script_name=$(basename "${script_source[0]}")
		echo "${USER}@$(hostname) running: ${script_root}/${script_name} $@"
	fi
}

# The below code will cause the pst_debug_echo function to be exported as an
# environment variable named: BASH_FUNC_pst_debug_echo%%
# it seems that this may not be necessary, so it is disabled for now.
#export -f pst_debug_echo

# correct usage of the pst_echo_bash_source script is the following
# which uses the BASH variable BASH_SOURCE to identify which file is currently executing
pst_debug_echo "$BASH_SOURCE"

alias pst_debug='export PST_DEBUG=1'

# if the inherited root has not been set, then set it now
# this should be the first thing we do
if [ -z "$PST_INHERITED_PATH" ]; then
	export PST_INHERITED_PATH=$PATH
fi 

# adds the user-specific bin directory, if it exists
if [ -d "${HOME}/bin" ] ; then
	# but only if it isn't already in the path
	if [[ ! "$PATH" = *"${HOME}/bin"* ]] ; then
		export PATH="${HOME}/bin:$PATH"
	fi
fi

# if we desire to reinitialize bash, we can do it here scratching the path
function rebash() {
	export PATH=$PST_INHERITED_PATH
	source $HOME/.bash_profile
}

# if the PST_ROOT is not set, then lets set it now
if [ -z "$PST_ROOT" ]; then
	PST_RELATIVE_ENTRYPOINT="$BASH_SOURCE"
	PST_ABSOLUTE_ROOT=$( cd $(dirname "$PST_RELATIVE_ENTRYPOINT") ; pwd -P )
	PST_ABSOLUTE_ENTRYPOINT="$PST_ABSOLUTE_ROOT"/"$(basename "$PST_RELATIVE_ENTRYPOINT")"
	export PST_ROOT=$PST_ABSOLUTE_ROOT
	unset PST_RELATIVE_ENTRYPOINT PST_ABSOLUTE_ROOT PST_ABSOLUTE_ENTRYPOINT
fi


if [ -z "$PST_OS" ]; then
	unamestr=$(uname)
	case $unamestr in
		Linux)
			PST_OS='linux'
			;;
		*BSD)
			PST_OS='bsd'
			;;
		Darwin)
			PST_OS='darwin'
			;;
		CYGWIN*)
			PST_OS='cygwin'
			;;
		*)
			PST_OS='unknown'
			;;
	esac
	unset unamestr
	# provide this to be used elsewhere in my scripts
	export PST_OS
fi
