#!/bin/sh


pst_debug_echo "$BASH_SOURCE"

# unique to OS
case "$PST_OS" in
	"darwin")
		
		function switchLink() {
			if [ "$#" -ne 2 ] ; then
				echo "ERROR: This script expects 1 argument, with syntax:" 1>&2
				echo "       switchLink <symbolicLink> <newTarget>" 1>&2
			elif [ ! -L "$1" ] ; then
				echo "ERROR: The first argument is not a symbolic link!" 1>&2
				return -1
			elif [ ! -e "$2" ] ; then 
				echo "ERROR: The second argument is not a symbolic link!" 1>&2
				return -1
			fi
			ln -s "$2" "$1"
		}
		
		if [ -n "$(type -t mount)" ] && [ -n "$(type -t grep)" ] ; then
			function testmount() {
				[ -d $1 ] && mount | grep -qs "on $1" > /dev/null
			}
		fi
				
		if [ -n "$(type -t namei)" ] ; then
#			alias nameiom='namei -om'
			function permchain() {
				namei -l $1 | awk '{print $3" "$5" "$6" "$1}'
			}
		fi
		
		if [ -n "$(type -t defaults)" ] ; then
				alias hide='defaults write com.apple.finder AppleShowAllFiles FALSE && killall Finder'
				alias unhide='defaults write com.apple.finder AppleShowAllFiles TRUE && killall Finder'
		fi
		
		if [ -n "$(type -t killall)" ] ; then
			alias killmc='killall Dock'
		fi
		
		if [ -n "$(type -t scutil)" ] ; then
			function fixVpnAssignedHostname() {
				read -p "Have you disconnected from the VPN? y/N : " proceed  
				proceed=${proceed:-n}
				if [ "y" != "$proceed" ] && [ "Y" != "$proceed" ] ; then
					echo "Aborting..."
					exit -1
				fi
				scutil --set HostName $(scutil --get LocalHostName)
				echo "You should be good to reconnect to the VPN, and get the correct hostname assignment"
			}
		fi
		
		if [ -n "$(type -t sshfs)" ] ; then
			function mountssh() {
				local osx_volume_name="$1"
				local ssh_user="$2"
				local ssh_host="$3"
				local remote_path="$4"
				local local_path="$5"
				sshfs -p 22 -o noappledouble -o volname="$osx_volume_name" "${ssh_user}@${ssh_host}:${remote_path}" "${local_path}"
			}
		fi
		
		# I could add to the existing OS the components called out below:
			# lesspipe
			# bash_completion
		# which i believe are available via homebrew
		# but for now i need to get other components working first
		
		
		;;
	
	
	"linux")
		
		function switchLink() {
			if [ "$#" -ne 2 ] ; then
				echo "ERROR: This script expects 1 argument, with syntax:" 1>&2
				echo "       switchLink <symbolicLink> <newTarget>" 1>&2
			elif [ ! -L "$1" ] ; then
				echo "ERROR: The first argument is not a symbolic link!" 1>&2
				return -1
			elif [ ! -e "$2" ] ; then 
				echo "ERROR: The second argument is not a symbolic link!" 1>&2
				return -1
			fi
			local tempLinkName=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
			ln -s "$2" "$tempLinkName"
			mv -T "$tempLinkName" "$1"
		}
		
		if [ -f /proc/mounts ] && [ -n "$(type -t grep)" ] ; then
			function testmount() {
				[ -d $1 ] && grep -qs "$1" /proc/mounts > /dev/null
			}
		fi
		
		
		if [ -n "$(type -t namei)" ] ; then
#			alias nameiom='namei -om'
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
	
