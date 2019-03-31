#!/bin/bash
set -ueo pipefail
#set -x

SCRIPT_ROOT=$(cd $(dirname "$BASH_SOURCE") ; pwd -P)
SCRIPT_NAME=$(basename "${BASH_SOURCE[0]}")
echo -e "\n${USER}@$(hostname) running: ${SCRIPT_ROOT}/${SCRIPT_NAME} $@"

## --------------------------------------------------------------------------------------- ##
## Install the mail client and associated MTA (mail transfer agent) used to forward emails ##
## --------------------------------------------------------------------------------------- ##

# optional argument to import a given mail configuration
MSMTPRC_PATH=${1:-}}


apt-get install -y msmtp msmtp-mta ca-certificates

# copy over the MSMTP configuration, if given
if [ -n ${MSMTPRC_PATH:-} ] && [ -f ${MSMTPRC_PATH} ] ; then
	cp -f ${MSMTPRC_PATH} /etc/msmtprc
	chmod u=r,go-rwx /etc/msmtprc
fi

# TODO: https://unix.stackexchange.com/questions/26666/can-i-change-roots-email-address-or-forward-it-to-an-external-address
# does this conflict with the msmtprc configuration?
