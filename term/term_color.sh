#!/bin/sh


pst_debug_echo "$BASH_SOURCE"


# this file is effectively a function for returning terminal color codes
# based on the detected terminal that you are running

# note that all color codes (non-printing characters) need to be wrapped
# in '\[' and '\]', and printing characters must not be.
# see: http://www.tldp.org/HOWTO/Bash-Prompt-HOWTO/nonprintingchars.html
# see: http://www.tldp.org/HOWTO/Bash-Prompt-HOWTO/bash-prompt-escape-sequences.html

getEsc8() {
	export c_datetime="\[\e[0;31m\]"		# Red
	export c_user="\[\e[0;92m\]"			# High Intensity Green
	export c_cwd="\[\e[0;35m\]"				# Purple
	export c_git="\[\e[0;96m\]"				# High Intensity Cyan
	export c_sep="\[\e[0;37m\]"				# White
	export c_prompt="\[\e[0;97m\]"			# High Intensity White
	export c_reset="\[\e[0m\]"				# resets all coloring
}

getEsc256() {
	export c_cwd="\[\e[38;5;172m\]"			# Orange
}

# TODO: check on begin/end non-printing characters
getTput8() {
	export c_datetime="$(tput setaf 1)"	# Red
	export c_user="$(tput setaf 10)"	# Intense Green
	export c_cwd="$(tput setaf 5)"		# Magenta
	export c_git="$(tput setaf 14)"		# High Intensity Cyan
	export c_sep="$(tput setaf 7)"		# White
	export c_prompt="$(tput setaf 15)"	# High Intensity White
	export c_reset="$(tput sgr0)"
}

getTput256() {
	export c_cwd="$(tput setaf 172)"	# Orange
	export c_user="$(tput setaf 46)"	# High Intensity Green
}

hasTput() {
	cmd_ref=`command -v tput > /dev/null`
	return $?
}

demo() {
	echo ${c_datetime} DATETIME ${c_reset}
	echo "${c_user}user@hostname${c_sep}:${c_cwd}/home/user${c_git} (feature/branch $=)${c_prompt}\n$\] ${c_reset}"
}

fullDemo() {
	echo "TPUT8"
	getTput8
	demo
	echo "TPUT256"
	getTput256
	demo
	echo "ESC8"
	getEsc8
	demo
	echo "ESC256"
	getEsc256
	demo
}

preferEsc() {
	case "$TERM" in
		xterm-256color)
			getEsc8
			getEsc256
			;;
		xterm*|rvxt*|screen*)
			getEsc8
			;;
		*)
			# if there is an unknown terminal, try to save with tput first
			hasTput
			if [ $? -eq 0 ] ; then
				getTput8
				if [[ $(tput colors) -ge 256 ]] 2>/dev/null ; then
					getTput256
				fi
			else
				getEsc8
			fi
			;;
	esac
}

preferTput() {
	# if there is an unknown terminal, try to save with tput first
	hasTput
	if [ $? -eq 0 ] ; then
		getTput8
		if [[ $(tput colors) -ge 256 ]] 2>/dev/null ; then
			getTput256
		fi
	else
		getEsc8
		if [ "$TERM" == "xterm-256color" ] ; then
				getEsc256
		fi
	fi
}

preferEsc

