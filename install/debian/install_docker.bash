#!/bin/bash
set -ueo pipefail
#set -x

SCRIPT_ROOT=$(cd $(dirname "$BASH_SOURCE") ; pwd -P)
SCRIPT_NAME=$(basename "${BASH_SOURCE[0]}")
echo -e "\n${USER}@$(hostname) running: ${SCRIPT_ROOT}/${SCRIPT_NAME} $@"

## -------------------------------------------------------- ##
## This script seeks to automate the installation of Docker ##
## -------------------------------------------------------- ##


apt-get -y install \
	apt-transport-https \
	ca-certificates \
	gnupg2 \
	software-properties-common
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
apt-key fingerprint 0EBFCD88
add-apt-repository \
	"deb [arch=amd64] https://download.docker.com/linux/debian \
	$(lsb_release -cs) \
	stable"
apt-get update
apt-get -y install docker-ce docker-ce-cli containerd.io

docker run hello-world
systemctl enable docker
systemctl start docker

# install the latest officially released version of docker-compose
DOCKER_COMPOSE_GIT_URL=https://github.com/docker/compose.git
DOCKER_COMPOSE_VERSION=$(git ls-remote --tags ${DOCKER_COMPOSE_GIT_URL} | cut -f 2 | sort -t '/' -k 3 --version-sort | grep -v "rc" | grep -v "docs" | tail -n1 | sed 's:.*/::')
curl -L "https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

################################################
## Grant given user permissions to run Docker ##
################################################
if [ ! -z "$1" ] ; then
	USER_NAME=${1:?target user name must be provided as an argument to this script}
	read -p "Give user[${USER_NAME}] Docker permissions? Y/n : " docker_permit_user
	docker_permit_user=${docker_permit_user:-y}
	if [ "y" == $(echo "${docker_permit_user}" | tr 'Y' 'y') ] ; then
		usermod -a -G docker "${USER_NAME}"
	fi
fi
