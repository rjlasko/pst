#!/bin/sh


pst_debug_echo "$BASH_SOURCE"

if [ -z "$(type -t docker)" ] ; then
	echo "It appears that the docker executable 'docker' is not in the path!"
	return
fi

#alias docker='sudo docker'
#alias docker-compose='sudo docker-compose'
#alias dkrcmp='docker-compose'
alias dkri="docker images -a"
alias dkrps='docker ps -a'
alias dkrv='docker volume ls'
alias dkrnt='docker network ls'

# useful docker daemon (dockerd) commands
alias dkrdrestart='sudo service docker restart'
alias dkrdlog='sudo journalctl -fu docker.service'
alias dkrdlogf='journalctl -fu docker _TRANSPORT=stdout + OBJECT_EXE=docker'


function dkrsh() {
	docker exec -it $1 /bin/sh
}

function dkrli() {
	docker exec -it $1 /bin/login
}

function dockerNukeContainer() {
	local name="$1"
	docker stop $(docker ps -a -q -f name="$name") 2>/dev/null
	docker rm $(docker ps -a -q -f name="$name") 2>/dev/null
}

function dockerNukeContainers() {
	for ctr in $(docker ps -a -q) ; do
		docker stop "$ctr"
		docker rm "$ctr"
	done
}

function dockerNukeImage() {
	local repository="$1"
	docker rmi $(docker images -a -q "$repository") 2>/dev/null
}

function dockerNukeImages() {
	for img in $(docker images -a -q) ; do
		docker rmi -f "$img"
	done
}

function dockerNukeVolumes() {
	for vol in $(docker volume ls -qf dangling=true) ; do
		docker volume rm "$vol"
	done
}

function dockerNukeAll() {
	(
		dockerNukeContainers
		dockerNukeImages
		dockerNukeVolumes
	)
}

function dkrTest() {
	: "${IMAGE_NAME:?ERROR: not set!}"
	: "${EXEC_CMD:?ERROR: not set!}"
	(
		set -x
		local name="test"
	#	docker build -t "$name" "$IMAGE_NAME"
		docker run \
			-it \
			-p 31415 \
			--cap-add=NET_ADMIN \
			--name "$name" \
			"$IMAGE_NAME" \
			$EXEC_CMD
		
		dockerNukeContainer "$name"
	#	docker rm "$name"
	)
}
function dkrUbuntu() {
	IMAGE_NAME="ubuntu:latest"
	EXEC_CMD="/bin/bash"
	dkrTest
}
function dkrPhusion() {
	IMAGE_NAME="phusion/baseimage:latest"
	EXEC_CMD="/bin/bash"
	dkrTest
}
function dkrAlpine() {
	IMAGE_NAME="alpine:latest"
	EXEC_CMD="/bin/sh"
	dkrTest
}
