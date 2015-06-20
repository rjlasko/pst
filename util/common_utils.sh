#!/bin/sh


pst_debug_echo "$BASH_SOURCE"

cmd_ref=`command -v column > /dev/null`
if [ $? -eq 0 ] ; then
	alias tcat='column -t'
	function tless () {
		column -t "$@" | less -S ;
	}
fi


cmd_ref=`command -v lsof > /dev/null`
if [ $? -eq 0 ] ; then
	function netspy () {
		lsof -i -P +c 0 +M | grep -i "$1"
	}
fi	


cmd_ref=`command -v md5sum > /dev/null`
cmd1_exit=$?
cmd_ref=`command -v openssl > /dev/null`
cmd2_exit=$?
if [ $cmd1_exit -ne 0 ] && [ $cmd2_exit -eq 0 ] ; then
	echo "YAY"
	alias md5sum='openssl md5'
fi

unset cmd_ref cmd1_exit cmd2_exit

# !!!!!!!!!!!!!!!!!!!! File/Directory Cleanup
# text editor artifacts
alias find~="find . -type f -name '*~' -ls"
alias cleanup~="find . -type f -name '*~' -ls -delete"
# OSX artifacts
alias findDS="find . -type f -name '.DS_Store' -ls"
alias cleanupDS="find . -type f -name '.DS_Store' -ls -delete"
# Windows artifacts
alias findThumbs="find . -type f -name 'Thumbs.db' -ls"
alias cleanupThumbs="find . -type f -name 'Thumbs.db' -ls -delete"
