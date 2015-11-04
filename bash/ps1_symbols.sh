#!/bin/sh


# Various variables you might want for your PS1 prompt
# see: http://www.tldp.org/HOWTO/Bash-Prompt-HOWTO/bash-prompt-escape-sequences.html

s_time24="\t"			# current time in 24-hour HH:MM:SS format
s_time12="\T"			# current time in 12-hour HH:MM:SS format
s_time_ap="\@"			# current time in 12-hour am/pm format
s_time_hm="\A"			# current time in 24-hour HH:MM format
s_fullpath="\W"			# basename of the current working directory, with $HOME abbreviated with a tilde
s_jobs="\j"				# number of jobs currently managed by the shell
s_fullhost="\H"		# full hostname
s_date="\d"				# date in “Weekday Month Date” format (e.g., “Tue May 26″)
s_datef="\D{format}"		# format is passed to strftime(3) and the result is inserted into the prompt string; an empty format results in a locale-specific time representation. The braces are required
s_termdevname="\l"		# basename of the shell’s terminal device name
s_carriage="\r"			# carriage return
s_shellname="\s"			# the name of the shell
s_backslash="\\"
s_escape="\033"			# ASCII escape character
s_histnum="\!"			# history number of this command
s_cmdnum="\#"			# command number of this command
s_datetime="\D{%F %T}"
s_user="\u"				# username of the current user
s_path="\w"				# current working directory, with $HOME abbreviated with a tilde
s_host="\h"				# hostname up to the first part
s_newline="\n"
s_uprompt="\$"			# if the effective UID is 0, '#', otherwise, '$'
