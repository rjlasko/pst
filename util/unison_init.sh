#!/bin/sh

pst_debug_echo "$BASH_SOURCE"

# run a test for the command in a subshell (using parentheses)
# and just return if it does not exist
if !(`command -v unison > /dev/null`) ; then
	echo "It appears that the Unison executable 'unison' is not in the path!"
	return
fi

export UNISONLOCALHOSTNAME="${1:?"unison_init.sh requires an input hostname parameter"}"
