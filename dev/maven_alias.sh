#!/bin/sh


pst_debug_echo "$BASH_SOURCE"

if [ -z "$(command -v mvn 2>/dev/null)" ] ; then
	echo "It appears that the Maven executable 'mvn' is not in the path!"
	return
fi


alias mvntest='mvn clean test'
alias mvninstall='mvn clean install'
alias mvninstallquick='mvn clean install -DskipTests'
alias mvnuprev='mvn versions:set -DgenerateBackupPoms=false'
alias mvndeptree='mvn dependency:tree -Dverbose'
alias gwtrun='mvn -Dgwt.style=pretty gwt:run'
alias gwtrun_clean='mvn -Dgwt.style=pretty clean war:exploded gwt:run -DskipTests'
alias tomrun='mvn tomcat:run'
alias tomwar='mvn tomcat:run-war'
