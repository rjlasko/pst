#!/bin/sh


pst_debug_echo "$BASH_SOURCE"

if [ -n "$(command -v column 2>/dev/null)" ] ; then
	alias tcat='column -t'
	function tless () {
		column -t "$@" | less -S ;
	}
fi


if [ -n "$(command -v lsof 2>/dev/null)" ] ; then
		function netspy () {
		lsof -i -P +c 0 +M | grep -i "$1"
	}
fi


if [ -n "$(command -v nmap 2>/dev/null)" ] ; then
	function lanmacs () {
		sudo nmap -sP 
	}
fi


if [ -z "$(command -v md5sum 2>/dev/null)" ] && [ -n "$(command -v openssl 2>/dev/null)" ] ; then
	alias md5sum='openssl md5'
fi

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
