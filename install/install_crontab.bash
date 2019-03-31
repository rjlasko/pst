#!/bin/bash
set -ueo pipefail
#set -x

SCRIPT_ROOT=$(cd $(dirname "$BASH_SOURCE") ; pwd -P)
SCRIPT_NAME=$(basename "${BASH_SOURCE[0]}")
echo -e "\n${USER}@$(hostname) running: ${SCRIPT_ROOT}/${SCRIPT_NAME} $@"

## ------------------------------------------------------------------------------- ##
## This script installs the preconfigured crontab, and other tools useful for cron ##
## ------------------------------------------------------------------------------- ##

# optional argument to import a given crontab
CRONTAB_PATH=${1:-}}


# install cronic to cleanup cron outputs for mailing errors
# requires 'bash'
curl -L http://habilis.net/cronic/cronic -o /usr/bin/cronic
chmod a=rx /usr/bin/cronic

# TODO: a utility that implements a file-based semaphore, to ensure locking when running a program
# see: https://serverfault.com/questions/82857/prevent-duplicate-cron-jobs-running
#apt-get install -y flock

# copy over the crontab configuration, if given
if [ -n ${CRONTAB_PATH:-} ] && [ -f ${CRONTAB_PATH} ] ; then
	cat ${CRONTAB_PATH} | crontab -
fi
