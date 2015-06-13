#!/bin/sh


pst_debug_echo "$BASH_SOURCE"

# run a test for the command in a subshell (using parentheses)
# and just return if it does not exist
if !(`command -v mvn > /dev/null`) ; then
	echo "It appears that the Maven executable 'mvn' is not in the path!"
	return
fi


alias mvntest='mvn clean test'
alias mvninstall='mvn clean install'
alias mvninstallquick='mvn clean install -DskipTests'
alias mvnuprev='mvn versions:set -DgenerateBackupPoms=false'
alias gwtrun='mvn gwt:run'
