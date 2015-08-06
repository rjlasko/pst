#!/bin/sh
# This script is the initialization point for Posix Shell Tools (PST).
# call this function to setup key environmental variables
# necessary to support running PST scripts.

# if the inherited root has not been set, then set it now
if [ -z "$PST_INHERITED_PATH" ]; then
	export PST_INHERITED_PATH=$PATH
else
	export PATH=$PST_INHERITED_PATH
fi 
	

alias pst_debug='export PST_DEBUG=1'

function pst_debug_echo() {
	if [ -n "$PST_DEBUG" ]; then
		echo "$1"
	fi
}
export -f pst_debug_echo
# correct usage of the pst_echo_bash_source script is the following
# which uses the BASH variable BASH_SOURCE to identify which file is currently executing
pst_debug_echo "$BASH_SOURCE"

# if the PST_ROOT is not set, then lets set it now
if [ -z "$PST_ROOT" ]; then
	PST_RELATIVE_ENTRYPOINT="$BASH_SOURCE"
	PST_ABSOLUTE_ROOT=$( cd $(dirname "$PST_RELATIVE_ENTRYPOINT") ; pwd -P )
	PST_ABSOLUTE_ENTRYPOINT="$PST_ABSOLUTE_ROOT"/"$(basename "$PST_RELATIVE_ENTRYPOINT")"
	export PST_ROOT=$PST_ABSOLUTE_ROOT
	unset PST_RELATIVE_ENTRYPOINT PST_ABSOLUTE_ROOT PST_ABSOLUTE_ENTRYPOINT
fi


if [ -z "$PST_OS" ]; then
	unamestr=`uname`
	case $unamestr in
		Linux)
			PST_OS='linux'
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
