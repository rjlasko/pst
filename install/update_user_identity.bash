#!/bin/bash
set -ueo pipefail
#set -xv

SCRIPT_ROOT=$(cd $(dirname "$BASH_SOURCE") ; pwd -P)
SCRIPT_NAME=$(basename "${BASH_SOURCE[0]}")
echo -e "\n${USER}@$(hostname) running: ${SCRIPT_ROOT}/${SCRIPT_NAME} $@"

## ---------------------------------------------------------- ##
## Creates or updates a user, and their corresponding groups. ##
# TODO: move this to PST
## -----------------------------------------------------------##

TARGET_USER_NAME=${TARGET_USER_NAME:-${1:?TARGET_USER_NAME must be provided as an argument to this script, or as an environment variable!}}


###########################
# Gather user & group ids #
###########################

# gather information first
if [ -z ${TARGET_GROUP_NAME:-} ] ; then
	read -p "Enter new primary GROUP name for ${TARGET_USER_NAME}? (skip) : " TARGET_GROUP_NAME
fi
if [ -n ${TARGET_GROUP_NAME:-} ] && [ -z ${TARGET_GROUP_ID:-} ] ; then
	read -p "Enter new GID for ${TARGET_GROUP_NAME}? (skip) : " TARGET_GROUP_ID
fi
if [ -z ${TARGET_USER_ID:-} ] ; then
	read -p "Enter new UID for ${TARGET_USER_NAME}? (skip) : " TARGET_USER_ID
fi


####################
# Create or update #
####################

if [ -n ${TARGET_GROUP_NAME:-} ] ; then
	if getent group ${TARGET_GROUP_NAME} > /dev/null ; then
		# modify
		GROUP_CMD="groupmod"
	else
		# create
		GROUP_CMD="addgroup"
	fi

	if [ -n ${TARGET_GROUP_ID:-} ] ; then
		GROUP_CMD="${GROUP_CMD} --gid ${TARGET_GROUP_ID}"
	fi

	eval "${GROUP_CMD} ${TARGET_GROUP_NAME}"
fi

if id ${TARGET_USER_NAME} > /dev/null ; then
	# modify
	USER_CMD="usermod"
else
	# create
	# gecos avoid requiring user input for finger fields
	USER_CMD="adduser --gecos ''"
fi
if [ -n ${TARGET_USER_ID:-} ] ; then
	USER_CMD="${USER_CMD} --uid ${TARGET_USER_ID}"
fi
if [ -n ${TARGET_GROUP_NAME:-} ] ; then
	USER_CMD="${USER_CMD} --gid ${TARGET_GROUP_ID}"
fi
if [ -n ${TARGET_USER_ID:-} ] || [ -n ${TARGET_GROUP_NAME:-} ] ; then
	eval "${USER_CMD} ${TARGET_USER_NAME}"
fi

if getent group ${TARGET_USER_NAME} > /dev/null ; then
	read -p "Delete group ${TARGET_USER_NAME}? Y/n : " drop_user_name_group
	drop_user_name_group=$(echo ${drop_user_name_group:-y} | tr 'Y' 'y')
	if [ "y" == "${drop_user_name_group}" ] ; then
		groupdel ${TARGET_USER_NAME}
	fi
fi


############################
# Setup admin user & group #
############################
read -p "Make user[${TARGET_USER_NAME}] a sudoer? Y/n : " sudo_permit_user
sudo_permit_user=$(echo ${sudo_permit_user:-y} | tr 'Y' 'y')
if [ "y" == "${sudo_permit_user}" ] ; then
	# make a sudoer, if not already in the sudoers file
	grep -q -F "${TARGET_USER_NAME}" /etc/sudoers || echo "${TARGET_USER_NAME}    ALL=(ALL:ALL) ALL" >> /etc/sudoers
	
	# also add the group if it is available
	if getent group sudo &> /dev/null ; then
		usermod --append --group sudo "${TARGET_USER_NAME}"
	fi
fi


echo "Updated user IDs:"
id ${TARGET_USER_NAME}

