#!/bin/sh

# #############################################################################
# this file is effectively a function for returning terminal color codes
# based on the detected terminal that you are running

# note that all color codes (non-printing characters) need to be wrapped
# in '\[' and '\]', and printing characters must not be.
# see: http://www.tldp.org/HOWTO/Bash-Prompt-HOWTO/nonprintingchars.html
# see: http://www.tldp.org/HOWTO/Bash-Prompt-HOWTO/bash-prompt-escape-sequences.html

# \x1B = \033 = <the escape character> = \e (sometimes) 
# \033 tends to be the most robust and commonly understood
# #############################################################################

# ------- Escaped 8-bit colors
c_datetime="\[\033[0;31m\]"		# Red
c_user="\[\033[0;92m\]"			# High Intensity Green
c_cwd="\[\033[0;35m\]"				# Purple
c_git="\[\033[0;96m\]"				# High Intensity Cyan
c_sep="\[\033[0;37m\]"				# White
c_prompt="\[\033[0;97m\]"			# High Intensity White
c_reset="\[\033[0m\]"				# resets all coloring

# ------- Escaped 256-bit colors
c_cwd="\[\033[38;5;172m\]"			# Orange

# ------- Terminfo 8-bit colors
# TODO: check on begin/end non-printing characters
c_datetime="$(tput setaf 1)"	# Red
c_user="$(tput setaf 10)"	# Intense Green
c_cwd="$(tput setaf 5)"		# Magenta
c_git="$(tput setaf 14)"		# High Intensity Cyan
c_sep="$(tput setaf 7)"		# White
c_prompt="$(tput setaf 15)"	# High Intensity White
c_reset="$(tput sgr0)"

# ------- Terminfo 256-bit colors
c_cwd="$(tput setaf 172)"	# Orange
c_user="$(tput setaf 46)"	# High Intensity Green

hasTput() {
	if [ -n "$(command -v tput 2>/dev/null)" ] ; then
		return 0
	else
		return 1
	fi
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
			if hasTput ; then
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

