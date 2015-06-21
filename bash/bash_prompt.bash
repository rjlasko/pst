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
	source $PST_ROOT/bash/ps1_symbols.sh
	
	if [ -z "$1" ]; then
		local PST_HOSTNAME=${s_host}
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
	
	
	local PST_PS_USER=${c_user}${s_user}"@"${PST_HOSTNAME}
	local PST_PS_CWT=${c_cwd}${s_path}
	local PST_PS_SEP=${c_sep}":"
	local PST_PS_PROMPT=${c_prompt}${s_newline}"$ "${c_reset}
	
	# add the git prompt if the associated input argument is defined
	if [ $2 -eq 1 ] ; then
		source $PST_ROOT/dev/git/git-prompt-setup.sh
		local PST_PS_GIT=${c_git}${GIT_PS1}
	fi
	
	# add the datetime if the associated input argument is defined
	if [ $3 -eq 1 ] ; then
		local PST_PS_DT=${c_datetime}${s_datetime}${PST_PS_SEP}
	fi
	
	# the default string to build based on the input args to this script
	# TODO: try to add handling for cases where some STDOUT does not end in a newline character
	# see: http://unix.stackexchange.com/questions/60459/how-to-make-bash-put-prompt-on-a-new-line-after-cat-command
	local PST_PS1=${PST_PS_DT}${PST_PS_USER}${PST_PS_SEP}${PST_PS_CWT}${PST_PS_GIT}${PST_PS_PROMPT}
	
	# add the chroot if it exists
	if [ -n $PST_PS_CHROOT ] ; then
		PST_PS1=${PST_PS_CHROOT}${PST_PS1}
	fi
	
	# If this is an xterm set the xterm title to user@host:dir
	case "$TERM" in
		xterm*|rxvt*)
			# note that we are surrounding the xterm title in '\[' and '\]', as the entire
			# thing is not printed out to the terminal, but rather the terminal container
			local PST_TERM_PS1="\[\e]0;"${PST_PS_CHROOT}${s_user}"@"${PST_HOSTNAME}":"${s_path}"\a\]"
			;;
		*)
			;;
	esac
	
	PS1=$PST_TERM_PS1$PST_PS1
	
	unset c_datetime c_user c_cwd c_git c_sep c_prompt c_reset
	unset s_datetime s_user s_path s_host s_newline s_uprompt
	unset setPS1
}
export -f setPS1

