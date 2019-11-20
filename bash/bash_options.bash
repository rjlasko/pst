#!/usr/bin/env bash


pst_debug_echo "$BASH_SOURCE"

# run a test to see if we are in the expected shell
# and just return if not
if [ -z "$BASH_VERSION" ]; then
	echo "It appears that BASH is not running!"
	return
fi

##############################################
# File + Directory creation permissions mask #
##############################################

# note that files are never created with their execution bits set, despite the mask
umask 027

###################
# History Options #
###################

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=erasedups

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=10000
HISTFILESIZE=1000000

# Don't put duplicate lines in the history.
# export HISTCONTROL=$HISTCONTROL${HISTCONTROL+,}ignoredups

# Ignore some controlling instructions
# HISTIGNORE is a colon-delimited list of patterns which should be excluded.
# The '&' is a special pattern which suppresses duplicate entries.
# export HISTIGNORE=$'[ \t]*:&:[fb]g:exit'
# export HISTIGNORE=$'[ \t]*:&:[fb]g:exit:ls' # Ignore the ls command as well

#################
# Shell Options #
#################

# See man bash for more options...

# Don't wait for job termination notification
# set -o notify

# Don't use ^D to exit
# set -o ignoreeof

# append to the history file, don't overwrite it
shopt -s histappend

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
# shopt -s globstar

# If set, the extended pattern matching features described under "Pathname Expansion" are enabled.
# shopt extglob

# Use case-insensitive filename globbing
# shopt -s nocaseglob

# When changing directory small typos can be ignored by bash
# for example, cd /vr/lgo/apaache would find /var/log/apache
# shopt -s cdspell
