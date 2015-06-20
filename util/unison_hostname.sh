#!/bin/sh

pst_debug_echo "$BASH_SOURCE"

# run a test for the command in a subshell (using parentheses)
# and just return if it does not exist
cmd_ref=`command -v unison > /dev/null`
if [ $? -ne 0 ] ; then
	echo "It appears that the Unison executable 'unison' is not in the path!"
	return
fi
unset cmd_ref


export UNISONLOCALHOSTNAME="${1:?"unison_init.sh requires an input hostname parameter"}"
