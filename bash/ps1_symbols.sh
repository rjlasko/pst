pst_debug_echo "$BASH_SOURCE"

# run a test to see if we are in the expected shell
# and just return if not
if [ -z "$BASH_VERSION" ]; then
	echo "It appears that BASH is not running!"
	return
fi


# Various variables you might want for your PS1 prompt instead
# see: http://www.tldp.org/HOWTO/Bash-Prompt-HOWTO/bash-prompt-escape-sequences.html

getUncommon() {
	export s_time24="\t"			# current time in 24-hour HH:MM:SS format
	export s_time12="\T"			# current time in 12-hour HH:MM:SS format
	export s_time_ap="\@"			# current time in 12-hour am/pm format
	export s_time_hm="\A"			# current time in 24-hour HH:MM format
	export s_fullpath="\W"			# basename of the current working directory, with $HOME abbreviated with a tilde
	export s_jobs="\j"				# number of jobs currently managed by the shell
	export s_fullhost="\H"		# full hostname
	export s_date="\d"				# date in “Weekday Month Date” format (e.g., “Tue May 26″)
#	export s_datef="\D{format}"		# format is passed to strftime(3) and the result is inserted into the prompt string; an empty format results in a locale-specific time representation. The braces are required
	export s_termdevname="\l"		# basename of the shell’s terminal device name
	export s_carriage="\r"			# carriage return
	export s_shellname="\s"			# the name of the shell
	export s_backslash="\\"
	export s_escape="\e"			# ASCII escape character
	export s_histnum="\!"			# history number of this command
	export s_cmdnum="\#"			# command number of this command
}

getCommon() {
	export s_datetime="\D{%F %T}"
	export s_user="\u"				# username of the current user
	export s_path="\w"				# current working directory, with $HOME abbreviated with a tilde
	export s_host="\h"				# hostname up to the first part
	export s_newline="\n"
	export s_uprompt="\$"			# if the effective UID is 0, '#', otherwise, '$'
}

getCommon
