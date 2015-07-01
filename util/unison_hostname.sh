#!/bin/sh

pst_debug_echo "$BASH_SOURCE"

if [ -z "$(command -v unison 2>/dev/null)" ] ; then
	echo "It appears that the Unison executable 'unison' is not in the path!"
	return
fi


export UNISONLOCALHOSTNAME="${1:?"unison_init.sh requires an input hostname parameter"}"
