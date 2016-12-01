#!/bin/sh


pst_debug_echo "$BASH_SOURCE"

if [ -z "$(type -t mvn)" ] ; then
	echo "It appears that the Maven executable 'mvn' is not in the path!"
	return
fi

if [ -n "$(type -t tput)" ] && [ -n "$(type -t sed)" ] ; then
	function mvn-color() {
		local c_bold=`tput bold`
		local c_red=`tput setaf 1`
		local c_green=`tput setaf 2`
		local c_yellow=`tput setaf 3`
		local c_blue=`tput setaf 4`
		local c_magenta=`tput setaf 5`
		local c_cyan=`tput setaf 6`
		local c_reset=`tput sgr0`
		
		# Filter mvn output using sed
		set -o pipefail
		
		# run the (non-aliased) 'mvn' command (/w args), passed through the sed-based color-izing filter
		# single-quote the mvn command to ensure that it is not replaced with the aliased value (mvn-color) which would result in an infinitely recursive loop
		'mvn' $@ | sed \
					-e "s/\(\[INFO] \)\(---\ .*\)/\1${c_magenta}\2${c_reset}/" \
					-e "s/\(\[INFO\]\)/${c_blue}\1${c_reset}/" \
					-e "s/\(\[DEBUG\]\)/${c_cyan}\1${c_reset}/" \
					-e "s/\(\[WARNING\]\)/${c_yellow}${c_bold}\1${c_reset}/" \
					-e "s/\(\[ERROR\]\)/${c_red}${c_bold}\1${c_reset}/" \
					-e "s/\(Tests run: \)\([^,]*\)\(, Failures: \)\([^,]*\)\(, Errors: \)\([^,]*\)\(, Skipped: \)\([^,]*\)/\1${c_bold}${c_green}\2${c_reset}\3${c_bold}${c_red}\4${c_reset}\5${c_bold}${c_red}\6${c_reset}\7${c_bold}${c_yellow}\4${c_reset}/"
#					-e "s/Tests run: \([^,]*\), Failures: \([^,]*\), Errors: \([^,]*\), Skipped: \([^,]*\)/Tests run: ${c_bold}${c_green}\1${c_reset}, Failures: ${c_bold}${c_red}\2${c_reset}, Errors: ${c_bold}${c_red}\3${c_reset}, Skipped: ${c_bold}${c_yellow}\4${c_reset}/"

		# preserve maven's exit status (otherwise masked by the pipe)
		local MVN_EXIT=${PIPESTATUS[0]}
		
		# Make sure formatting is reset
		echo -ne ${c_reset}
		
		# ensure that we return maven's status code
		return $MVN_EXIT
	}
	
	alias mvn='mvn-color'
fi

alias mvntest_debug='mvn test -Dmaven.surefire.debug'
alias mvninstall='mvn clean install'
alias mvninstallquick='mvn clean install -DskipTests'
alias mvnuprev="'mvn' versions:set -DgenerateBackupPoms=false"
alias mvndeptree='mvn dependency:tree -Dverbose'
alias gwtrun='mvn -Dgwt.style=pretty gwt:run'
alias gwtrun_clean='mvn -Dgwt.style=pretty clean war:exploded gwt:run -DskipTests'
alias tomrun='mvn tomcat:run'
alias tomwar='mvn tomcat:run-war'
