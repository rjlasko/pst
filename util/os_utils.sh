#!/bin/sh


pst_debug_echo "$BASH_SOURCE"

# unique to OS
case "$PST_OS" in
	"darwin")
		
		if [ -n "$(command -v mount 2>/dev/null)" ] && [ -n "$(command -v grep 2>/dev/null)" ] ; then
			function testmount() {
				[ -d $1 ] && mount | grep -qs "on $1" > /dev/null
			}
		fi
				
		if [ -n "$(command -v defaults 2>/dev/null)" ] && [ -n "$(command -v killall 2>/dev/null)" ] ; then
			alias hide='defaults write com.apple.finder AppleShowAllFiles FALSE && killall Finder'
			alias unhide='defaults write com.apple.finder AppleShowAllFiles TRUE && killall Finder'
		fi
		
		# I could add to the existing OS the components called out below:
			# lesspipe
			# bash_completion
		# which i believe are available via homebrew
		# but for now i need to get other components working first
		
		;;
	
	
	"linux")
		
		if [ -n "$(command -v namei 2>/dev/null)" ] ; then
			alias permchain='namei -l'
		fi
		
		
		if [ -f /proc/mounts ] && [ -n "$(command -v grep 2>/dev/null)" ] ; then
			function testmount() {
				[ -d $1 ] && grep -qs "$1" /proc/mounts > /dev/null
			}
		fi
		
		# make less more friendly for non-text input files, see lesspipe(1)
		[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"
	
		# enable programmable completion features (you don't need to enable
		# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
		# sources /etc/bash.bashrc).
		if ! shopt -oq posix; then
			if [ -f /usr/share/bash-completion/bash_completion ]; then
				. /usr/share/bash-completion/bash_completion
			elif [ -f /etc/bash_completion ]; then
				. /etc/bash_completion
			fi
		fi
		;;
	
	
	*) ##### OS NOT DETECTED! #####
		;;
esac
	