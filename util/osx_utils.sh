#!/bin/sh


pst_debug_echo "$BASH_SOURCE"

# unique to OS
case "$PST_OS" in
	"darwin")
		
		if (`command -v defaults > /dev/null`) ; then
			alias hide='defaults write com.apple.finder AppleShowAllFiles FALSE && killall Finder'
			alias unhide='defaults write com.apple.finder AppleShowAllFiles TRUE && killall Finder'
		fi
		;;
	
	*) ##### OS NOT DETECTED! #####
		;;
esac
	