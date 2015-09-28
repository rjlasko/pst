#!/bin/sh


pst_debug_echo "$BASH_SOURCE"

if [ -n "$(command -v column 2>/dev/null)" ] ; then
	alias tcat='column -t'
	function tless () {
		column -t "$@" | less -S ;
	}
fi


if [ -z "$(command -v md5sum 2>/dev/null)" ] && [ -n "$(command -v openssl 2>/dev/null)" ] ; then
	alias md5sum='openssl md5'
fi


if [ -n "$(command -v lsof 2>/dev/null)" ] ; then
	function netspy () {
		lsof -i -P +c 0 +M | grep -i "$1"
	}
fi


if [ -n "$(command -v ifconfig 2>/dev/null)" ] ; then
	alias myip="ifconfig | sed -En 's/127.0.0.1//;s/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p'"

	if [ -n "$(command -v nmap 2>/dev/null)" ] ; then
		
		function lanmacs () {
			local myips=`myip`
			for ip in $myips ; do
				local a=`cut -f1-3 -d"." <(echo $ip)`
				local seg=$a".*"
				echo "-------------------------------------------------------------------------"
				echo "Finding Hosts in LAN segment: "$seg
				echo "-------------------------------------------------------------------------"
				sudo nmap -sP $seg
			done
		}
		
		function scanip() {
			sudo nmap -sP $1
		}
	fi
fi


if [ -n "$(command -v grep 2>/dev/null)" ] && [ -n "$(command -v sed 2>/dev/null)" ] && [ -n "$(command -v tr 2>/dev/null)" ] ; then

	# find out if we have a GNU or BSD grep
	_GREP_TYPE=$(grep --version | head -n1 | tr '[A-Z]' '[a-z]')
	
	case $_GREP_TYPE in
		*"gnu grep"*)
			function numPtreeFiles() {
				#(lsof -p `pstree -p $1 | grep -o "[0-9]*" | tr '\n' ','` 2>/dev/null) | awk '{print $2}' | tail -n +2 | uniq -c
				
				while true
				do
					(lsof -p `pstree -p $1 | grep -o "[0-9]*" | tr '\n' ','` 2>/dev/null) | awk '{print $2}' | tail -n +2 | uniq -c
					echo "-----------"
					sleep 1
				done
			}
			;;

		*"bsd grep"*)
			function numPtreeFiles() {
				echo "does not work yet because OSx grep has shitty regex support!"
				# pstree -p $1 | grep -o "[0-9]*"
				return 1
			}
			;;
		*)
			function numPtreeFiles() {
				echo "unrecognized grep command"
				return 1
			}
			;;
	esac
	unset _GREP_TYPE
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
