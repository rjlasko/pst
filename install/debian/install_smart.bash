#!/bin/bash
set -ueo pipefail
#set -x

SCRIPT_ROOT=$(cd $(dirname "$BASH_SOURCE") ; pwd -P)
SCRIPT_NAME=$(basename "${BASH_SOURCE[0]}")
echo -e "\n${USER}@$(hostname) running: ${SCRIPT_ROOT}/${SCRIPT_NAME} $@"

## ---------------------------------------------------------------- ##
## Installs SMART monitoring tools, and configures smartd as desired ##
## ---------------------------------------------------------------- ##
# https://www.smartmontools.org
# https://www.lisenet.com/2014/using-smartctl-smartd-and-hddtemp-on-debian/
# https://help.ubuntu.com/community/Smartmontools#Advanced:_Running_as_Smartmontools_as_a_Daemon
# https://wiki.archlinux.org/index.php/S.M.A.R.T.

ALERT_EMAIL=${1:?An email address must be provided as an argument to this script!}}


##################################
# Install SMART monitoring tools #
##################################
apt-get install -y smartmontools


##########################################
# Configure SMART Disk Monitoring Daemon #
##########################################
# uncomment the 'start_smartd' line to include in systems start 
sed -i '/start_smartd/c\start_smartd=yes' /etc/default/smartmontools

# Notes on scheduling choices:
# "DEVICESCAN" - scans all connected disk devices
# "-a" - monitors all attributes
# "-S on" - enable attribute auto-save
# "-o off" - disable SMART Automatic Offline Testing (in favor of daily short tests)
# "-W 4,35,40" - track temperature changes (log 4deg changes, log hit 35deg, log & email warning @ 40deg)
# "-m ${ALERT_EMAIL}" - email alerts to that account
# "-M test" - send test email for each device on SMART daemon restart
# "-s (S/../(02|10|18|26)/./03|L/../28/./03)" - short @ 3am (2nd,10th,18th,26th of the month), long @ 3am (28th of the month)

cp -f /etc/smartd.conf /etc/smartd.conf.bak
echo "DEVICESCAN -a -S on -o off -W 4,35,40 -m ${ALERT_EMAIL} -M test -s (S/../(02|10|18|26)/./03|L/../28/./03)" > /etc/smartd.conf

# restart reconfigured service
/etc/init.d/smartmontools restart
