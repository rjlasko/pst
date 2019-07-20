#!/bin/sh


pst_debug_echo "$BASH_SOURCE"

if [ -n "$(type -t screen)" ] ; then
	echo "<<<<<<<<<< Screen Status >>>>>>>>>>"
	screen -ls
else
	echo "It appears that the executable 'screen' is not in the path!"
	return
fi
