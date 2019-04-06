#!/bin/bash
set -ueo pipefail
set -xv

SCRIPT_ROOT=$(cd $(dirname "$BASH_SOURCE") ; pwd -P)
SCRIPT_NAME=$(basename "${BASH_SOURCE[0]}")
echo ""
echo "${USER}@$(hostname) running: ${SCRIPT_ROOT}/${SCRIPT_NAME} $@"

## This script seeks to configure SSH root login
ROOT_LOGIN_MODE=${1:?}
case ${1:-} in
	"yes" | "prohibit-password" | "without-password" | "forced-commands-only" | "no" )
		# replace the first occurrence of PermitRootLogin w/ desired setting (default=prohibit-password)
		sed -i '0,/.*PermitRootLogin.*/s//PermitRootLogin '${1}'/' /etc/ssh/sshd_config
		/etc/init.d/ssh restart
		;;
	*)
		echo "ERROR: Argument must be one of: [yes, prohibit-password, without-password, forced-commands-only, no]"
		exit 1
		;;
esac


