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

# this alias only applies to OSx systems...  prolly want to have the proper conditional in front of it...
alias dkrtty='screen ~/Library/Containers/com.docker.docker/Data/com.docker.driver.amd64-linux/tty'

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
	for vol in $(docker volume ls -q -f dangling=true) ; do
		docker volume rm "$vol"
	done
}

function dockerCleanAll() {
	echo "- Containers..."
		for ctr in $(docker ps -a -q -f "status=exited") ; do
		docker rm "$ctr"
	done
	
	echo "- Images..."
	for img in $(docker images -a -q -f "dangling=true") ; do
		docker rmi -f "$img"
	done
	
	echo "- Volumes..."
	dockerNukeVolumes
}

function dockerNukeAll() {
	(
		echo "- Containers..."
		dockerNukeContainers
		echo "- Images..."
		dockerNukeImages
		echo "- Volumes..."
		dockerNukeVolumes
	)
}

function dkrRunImageD() {
	(
		DKR_CMD_OPTS="$DKR_CMD_OPTS -d"
		dkrRunImage
	)
}

function dkrRunImageIT() {
	(
		DKR_CMD_OPTS="$DKR_CMD_OPTS -it"
		dkrRunImage
	)
}

function dkrRunImage() {
	: "${IMAGE_NAME:?ERROR: not set!}"
	: "${EXEC_CMD:?ERROR: not set!}"
	(
		set -x
		local name="test"
		DKR_CMD_OPTS="$DKR_CMD_OPTS \
			-v /etc/localtime:/etc/localtime \
			-p 31415:31415 \
			--cap-add=NET_ADMIN \
			--device /dev/net/tun"
			
		docker run \
			$DKR_CMD_OPTS \
			--name "$name" \
			"$IMAGE_NAME" \
			$EXEC_CMD
		
		dockerNukeContainer "$name"
	)
}

function dkrStartContainer() {
	: "${IMAGE_NAME:?ERROR: not set!}"
	(
		set -x
		local name="test"
		
		DKR_CMD_OPTS="$DKR_CMD_OPTS \
			-v /etc/localtime:/etc/localtime \
			-p 31415:31415 \
			--cap-add=NET_ADMIN \
			--device /dev/net/tun"
		
		docker create \
			$DKR_CMD_OPTS \
			--name "$name" \
			"$IMAGE_NAME"
			
		docker start "$name"
		
		docker logs -f "$name"
	)
}

function dkrCompose() {
	: "${COMPOSE_DIR:?ERROR: not set!}"
	(
		set -x
		pushd "$COMPOSE_DIR"
		
		if [ -n "$COMPOSE_FILE" ] ; then
			docker-compose -f $COMPOSE_FILE up -d --remove-orphans --build
		else
			docker-compose up -d --remove-orphans --build
		fi
		
		popd
	)
}
