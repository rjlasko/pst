#!/bin/bash
set -ueo pipefail
#set -xv

SCRIPT_ROOT=$(cd $(dirname "$BASH_SOURCE") ; pwd -P)
SCRIPT_NAME=$(basename "${BASH_SOURCE[0]}")
echo -e "\n${USER}@$(hostname) running: ${SCRIPT_ROOT}/${SCRIPT_NAME} $@"

## ------------------------------------------------------------ ##
## Installs ZFS on Linux, and mounts/imports any pools detected ##
## ------------------------------------------------------------ ##
# https://github.com/zfsonlinux/zfs/wiki/Debian

# optional argument to attempt to import a zPool of the given name
ZPOOL_NAME=${1:-}}


# temporarily allow errors to detect if zfs has already been installed
set +e
ZFS_UTIL_LOCATION=$(which zfs)
ZFS_EXISTS=$?
set -e

# TODO : get a better test to determine if zfs is correctly installed: ex. the given zPool is detected 
if [ $ZFS_EXISTS -eq 0 ] ; then
	# return early if already installed
	echo "Skipping install of ZFS: pre-existing installation detected"
else
	# add extra DEBIAN repositories to apt-get
	NEW_REPOS="contrib non-free"
	APT_SOURCES="/etc/apt/sources.list"
	if [ ! -e $APT_SOURCES ] ; then
		>&2 echo "ERROR: $APT_SOURCES not found"
	fi
	WORK_DIR=$(mktemp -d)
	APT_SOURCES_TMP="${WORK_DIR}/sources.list"
	grep "^[^#;]" $APT_SOURCES | sort > $APT_SOURCES_TMP
	sed -i.bak '/stretch/ s/$/ '"$NEW_REPOS"'/' $APT_SOURCES_TMP
	cp $APT_SOURCES_TMP $APT_SOURCES
	
	# update the added sources, otherwise ZFS won't be found!
	apt-get update -y

	########################
	# Install ZFS-on-Linux #
	########################
	apt-get install -y linux-headers-$(uname -r)
	# addresses a bug with the install
	if [ ! -e "/usr/bin/rm" ] ; then
		ln -s /bin/rm /usr/bin/rm
	fi
	apt-get install -y zfs-dkms zfsutils-linux
	
	#######################
	# Configure ZFS Pools #
	#######################
	modprobe zfs
	
	if [ -n ${ZPOOL_NAME:-} ] ; then
		# this should survive a reboot
		zpool import -f ${ZPOOL_NAME}
	fi
fi


################################
# Install ZFS snapshot utility #
################################
apt-get -y install zfs-auto-snapshot

zfs list
