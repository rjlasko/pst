#!/bin/sh


pst_debug_echo "$BASH_SOURCE"

# run a test for the command in a subshell (using parentheses)
# and just return if it does not exist
cmd_ref=`command -v mvn > /dev/null`
if [ $? -ne 0 ] ; then
	echo "It appears that the Maven executable 'mvn' is not in the path!"
	return
fi
unset cmd_ref


alias mvntest='mvn clean test'
alias mvninstall='mvn clean install'
alias mvninstallquick='mvn clean install -DskipTests'
alias mvnuprev='mvn versions:set -DgenerateBackupPoms=false'
alias gwtrun='mvn gwt:run'
