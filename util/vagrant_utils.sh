#!/usr/bin/env sh


pst_debug_echo "$BASH_SOURCE"

if [ -z "$(type -t vagrant)" ] ; then
	echo "It appears that the executable 'vagrant' is not in the path!"
	return
fi


# begin aliases and functions
export VAGRANT_HOME="/zDisk/vm/vagrant"
