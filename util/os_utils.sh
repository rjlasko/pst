#!/bin/sh


pst_debug_echo "$BASH_SOURCE"

# unique to OS
case "$PST_OS" in
	"darwin")
		
		if [ -n "$(type -t mount)" ] && [ -n "$(type -t grep)" ] ; then
			function testmount() {
				[ -d $1 ] && mount | grep -qs "on $1" > /dev/null
			}
		fi
				
		if [ -n "$(type -t namei)" ] ; then
			function permchain() {
				namei -l $1 | awk '{print $3" "$5" "$6" "$1}'
			}
		fi
		
		if [ -n "$(type -t killall)" ] ; then
			alias killmc='killall Dock'
			if [ -n "$(type -t defaults)" ] ; then
					alias hide='defaults write com.apple.finder AppleShowAllFiles FALSE && killall Finder'
					alias unhide='defaults write com.apple.finder AppleShowAllFiles TRUE && killall Finder'
			fi
		fi
		
		# I could add to the existing OS the components called out below:
			# lesspipe
			# bash_completion
		# which i believe are available via homebrew
		# but for now i need to get other components working first
		
		
		;;
	
	
	"linux")
		
		if [ -f /proc/mounts ] && [ -n "$(type -t grep)" ] ; then
			function testmount() {
				[ -d $1 ] && grep -qs "$1" /proc/mounts > /dev/null
			}
		fi
		
		if [ -n "$(type -t namei)" ] ; then
			alias permchain='namei -l'
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
	
