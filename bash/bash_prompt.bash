#!/bin/bash


pst_debug_echo "$BASH_SOURCE"

# run a test to see if we are in the expected shell
# and just return if not
if [ -z "$BASH_VERSION" ]; then
	echo "It appears that BASH is not running!"
	return
fi


# ------- ENVIRONMENT SPECIFIC CAPABILITIES + OVERRIDES -------
# TODO: this should be moved to the .bashrc for each individual machine, or something cygwin specific 
case "$PST_OS" in
	"cygwin")
		# this is a CYGWIN specific override.  i know that the version can support 256 colors,
		# even though its TERM environment variable indicates just "xterm" 
		export TERM=xterm-256color
		;;
esac


# ------- PS1 DEFINITION -------
function pst_setPS1() {
	
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
	
	# calling out the default colors using escape codes here for simplicity.
	# NOTE: color codes used within $PS1 need to be wrapped by '\[' and '\]'
	local c_user="\[\033[0;92m\]"			# High Intensity Green
	local c_cwd="\[\033[0;35m\]"			# Purple
	local c_reset="\[\033[0m\]"				# resets all coloring
	# overrides for terminals handling 256-colors
	if [ "$TERM" == "xterm-256color" ] ; then
		c_cwd="\[\033[38;5;172m\]"			# Orange
	fi

	local s_user="\u"				# username of the current user
	local s_path="\w"				# current working directory, with $HOME abbreviated with a tilde
	local s_newline="\n"

	# use the system's hostname if one is not provided
	if [ -z "$1" ]; then
		local PST_HOSTNAME="\h" # hostname up to the first part
	else
		local PST_HOSTNAME="$1"
	fi
	
	local PST_PS_USER=${c_user}${s_user}"@"${PST_HOSTNAME}
	local PST_PS_CWD=${c_cwd}${s_path}
	local PST_PS_SEP=${c_reset}":"
	local PST_PS_PROMPT=${c_reset}${s_newline}"$ "
	
	# add the git prompt
	if [ $2 -eq 1 ] ; then
		source $PST_ROOT/dev/git/git-prompt-setup.sh
		local c_git="\[\033[0;96m\]" # High Intensity Cyan
		local PST_PS_GIT=${c_git}${GIT_PS1}
	fi
	
	# add the datetime
	if [ $3 -eq 1 ] ; then
		local c_datetime="\[\033[0;31m\]" # Red
		local s_datetime="\D{%F %T}"
		local PST_PS_DT=${c_datetime}${s_datetime}${PST_PS_SEP}
	fi
	
	# the default string to build based on the input args to this script
	local PST_PS1=${PST_PS_DT}${PST_PS_USER}${PST_PS_SEP}${PST_PS_CWD}${PST_PS_GIT}${PST_PS_PROMPT}
	
	# add the chroot if it exists
	if [ -n $PST_PS_CHROOT ] ; then
		PST_PS1=${PST_PS_CHROOT}${PST_PS1}
	fi
	
	# If this is an xterm set the xterm title to user@host:dir
	case "$TERM" in
		xterm*|rxvt*)
			# note that we are surrounding the xterm title with special control characters, as the entire
			# thing is not printed out to the terminal, but rather the terminal container
			local PST_TERM_PS1="\[\033]0;"${PST_PS_CHROOT}${s_user}"@"${PST_HOSTNAME}":"${s_path}"\a\]"
			;;
		*)
			;;
	esac
	
	PS1=$PST_TERM_PS1$PST_PS1
	
	# add newline handling
	if [ $4 -eq 1 ] ; then
		PROMPT_COMMAND=pst_ps1ResolveNewLine
	else
		unset PROMPT_COMMAND
	fi
	
	unset pst_setPS1
}

function pst_ps1ResolveNewLine() {
	local cmdRowCol='\033[6n'
	local reset='\033[0m'
	local blink='\033[5m'
	local inverse='\033[7m'
	local indicator=$blink$inverse"%"$reset
	
	# derived from:
	# http://stackoverflow.com/questions/19943482/configure-shell-to-always-print-prompt-on-new-line-like-zsh
	#
	# FIXME !!
	# sadly this technique yields some extra junk logged to the prompt every now and then.
	# it happens most frequently within a OSX 'screen' session...
	local curpos
	echo -en $cmdRowCol
	IFS=';' read -s -d R -a curpos
	#curpos[0]="${curpos[0]:2}"  # strip leading ESC[
	(( curpos[1] > 1 )) && echo -e $indicator
}
