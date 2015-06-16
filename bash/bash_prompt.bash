#!/bin/bash


pst_debug_echo "$BASH_SOURCE"

# run a test to see if we are in the expected shell
# and just return if not
if [ -z "$BASH_VERSION" ]; then
	echo "It appears that BASH is not running!"
	return
fi


# ------- ENVIRONMENT SPECIFIC CAPABILITIES + OVERRIDES -------
case "$PST_OS" in
	"cygwin")
		# this is a CYGWIN specific override.  i know that the version can support 256 colors,
		# even though its TERM environment variable indicates just "xterm" 
		export TERM=xterm-256color
		;;
esac


# ------- PS1 DEFINITION -------
function setPS1() {
	
	source $PST_ROOT/term/term_color.sh
	
	if [ -z "$1" ]; then
		local PST_HOSTNAME="\h"
	else
		local PST_HOSTNAME="$1"
	fi
	
	# debian chroot handling
	case "$PST_OS" in
		"linux")
			# set variable identifying the chroot you work in (used in the prompt below)
			if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
				local debian_chroot=$(cat /etc/debian_chroot)
			fi
			local PST_PS_CHROOT='${debian_chroot:+($debian_chroot)}'
			;;
	esac
	
	
	local PST_PS_USER=${c_user}"\u@"${PST_HOSTNAME}
	local PST_PS_CWT=${c_cwd}"\w"
	local PST_PS_SEP=${c_sep}":"
	local PST_PS_PROMPT=${c_prompt}"\n$ "${c_reset}
	
	if [ -n "$2" ] ; then
		source $PST_ROOT/dev/git/git-prompt-setup.sh
		local PST_PS_GIT=${c_git}${GIT_PS1}
	fi
	
	if [ -n "$3" ] ; then
		local PST_PS_DT=${c_datetime}"\D{%F %T}"${PST_PS_SEP}
	fi
	
	#PS1=${PST_PS_USER}${PST_PS_SEP}${PST_PS_CWT}${PST_PS_GIT}${PST_PS_PROMPT}
	PS1=${PST_PS_DT}${PST_PS_USER}${PST_PS_SEP}${PST_PS_CWT}${PST_PS_GIT}${PST_PS_PROMPT}
	if [ -n $PST_PS_CHROOT ]
	then
		PS1=${PST_PS_CHROOT}${PS1}
	fi
	
	# If this is an xterm set the xterm title to user@host:dir
	case "$TERM" in
		xterm*|rxvt*)
			PS1="\[\e]0;"${PST_PS_CHROOT}"\u@"${PST_HOSTNAME}":\w\a\]$PS1"
			;;
		*)
			;;
	esac
	
	unset c_datetime c_user c_cwd c_white c_git c_sep c_prompt c_reset
}
export -f setPS1

