#!/bin/sh


pst_debug_echo "$BASH_SOURCE"

if (`command -v column > /dev/null`) ; then
	alias tcat='column -t'
	function tless () {
		column -t "$@" | less -S ;
	}
fi


if (`command -v lsof > /dev/null`) ; then
	function netspy () {
		lsof -i -P +c 0 +M | grep -i "$1"
	}
fi	


if !(`command -v md5sum > /dev/null`) && (`command -v openssl > /dev/null`) ; then
	alias md5sum='openssl md5'
fi
