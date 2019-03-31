#!/bin/bash
set -ueo pipefail
#set -xv

SCRIPT_ROOT=$(cd $(dirname "$BASH_SOURCE") ; pwd -P)
SCRIPT_NAME=$(basename "${BASH_SOURCE[0]}")
echo ""
echo "${USER}@$(hostname) running: ${SCRIPT_ROOT}/${SCRIPT_NAME} $@"

## This script seeks to enable SSH root login

# replace the first occurrence of PermitRootLogin w/ desired setting
sed -i '0,/.*PermitRootLogin.*/s//PermitRootLogin yes/' /etc/ssh/sshd_config

/etc/init.d/ssh restart
