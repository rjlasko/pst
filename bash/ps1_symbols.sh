pst_debug_echo "$BASH_SOURCE"

# run a test to see if we are in the expected shell
# and just return if not
if [ -z "$BASH_VERSION" ]; then
	echo "It appears that BASH is not running!"
	return
fi


# Various variables you might want for your PS1 prompt instead
Time24="\t"				# current time in 24-hour HH:MM:SS format
Time12="\T"				# current time in 12-hour HH:MM:SS format
TimeAP="\@"				# current time in 12-hour am/pm format
TimeHM="\A"				# current time in 24-hour HH:MM format
User="\u"				# username of the current user
PathShort="\w"			# current working directory, with $HOME abbreviated with a tilde
PathFull="\W"			# basename of the current working directory, with $HOME abbreviated with a tilde
NewLine="\n"
Jobs="\j"				# number of jobs currently managed by the shell
Hostname="\h"			# hostname up to the first part
HostnameFull="\H"		# full hostname
Date="\d"				# date in “Weekday Month Date” format (e.g., “Tue May 26″)
#DateF="\D{format}"		# format is passed to strftime(3) and the result is inserted into the prompt string; an empty format results in a locale-specific time representation. The braces are required
DateTime="\D{%F %T}"
TermDevName="\l"		# basename of the shell’s terminal device name
NewLine="\n"			# newline
ShellName="\s"			# the name of the shell
