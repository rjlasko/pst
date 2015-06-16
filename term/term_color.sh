#!/bin/sh


pst_debug_echo "$BASH_SOURCE"


# this file is effectively a function for returning terminal color codes
# based on the detected terminal that you are running

getEsc8() {
	export c_datetime="\\033[0;31m"	# Red
	export c_user="\\033[0;92m"		# High Intensity Green
	export c_cwd="\\033[0;35m"		# Purple
	export c_git="\\033[0;96m"		# High Intensity Cyan
	export c_sep="\\033[0;37m"		# White
	export c_prompt="\\033[0;97m"	# High Intensity White
	export c_reset="\\033[0m"
}

getEsc256() {
	export c_cwd="\\033[38;5;172m"		# Orange
}

getTput8() {
	export c_datetime="$(tput setaf 1)"			# Red
	export c_user="$(tput setaf 10)"			# Intense Green
	export c_cwd="$(tput setaf 5)"				# Magenta
	export c_git="$(tput setaf 14)"				# High Intensity Cyan
	export c_sep="$(tput setaf 7)"				# White
	export c_prompt="$(tput setaf 15)"			# High Intensity White
	export c_reset="$(tput sgr0)"
}

getTput256() {
	export c_cwd="$(tput setaf 172)"			# Orange
	export c_user="$(tput setaf 46)"			# High Intensity Green
}

demo() {
	echo "${c_datetime} DATETIME ${c_reset}"
	echo "${c_user}puck@sn0wGun${c_sep}:${c_cwd}/home/rlasko/scratch${c_git} (feature/qcFlagsLocked $=)${c_prompt}\n$ ${c_reset}"
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
		if (`command -v tput > /dev/null`) ; then
			getTput8
			if [[ $(tput colors) -ge 256 ]] 2>/dev/null ; then
				getTput256
			fi
		else
			getEsc8
		fi
		;;
esac
