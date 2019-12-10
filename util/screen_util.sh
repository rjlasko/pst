#!/usr/bin/env sh


pst_debug_echo "$BASH_SOURCE"

if [ -z "$(type -t screen)" ] ; then
	echo "It appears that the executable 'screen' is not in the path!"
	return
fi

echo "<<<<<<<<<< Screen Status >>>>>>>>>>"
screen -ls


# begin aliases and functions
