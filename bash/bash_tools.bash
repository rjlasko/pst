#!/bin/bash


pst_debug_echo "$BASH_SOURCE"

# run a test to see if we are in the expected shell
# and just return if not
if [ -z "$BASH_VERSION" ]; then
	echo "It appears that BASH is not running!"
	return
fi


function get_etc_bashrc() {
	if [ -f "/etc/bashrc" ]; then
		. "/etc/bashrc"
	fi
}

alias rebash='source $HOME/.bash_profile'
