#!/bin/sh


pst_echo_bash_source "$BASH_SOURCE"

# XXX this appears not to be needed...
# fname=`declare -f -F function_exists`
# if [ -n "$fname" ]
# then
# 	function function_exists() {
# 		declare -f -F $1 > /dev/null
# 		return $?
# 	}
# 	export -f function_exists
# fi
# unset fname
