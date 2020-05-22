#!/usr/bin/env sh


pst_debug_echo "$BASH_SOURCE"

if [ -z "$(type -t docker)" ] ; then
	echo "It appears that the executable 'docker' is not in the path!"
	return
fi
echo "<<<<<<<<<< Docker Container Status >>>>>>>>>>"
docker ps --all --format "table {{.ID}}\t{{.Image}}\t{{.Names}}\t{{.CreatedAt}}\t{{.Status}}"
echo


# begin aliases and functions
alias dkrps='docker ps --all --format "table {{.ID}}\t{{.Image}}\t{{.Names}}\t{{.CreatedAt}}\t{{.Status}}"'
alias dkri="docker images -a"
alias dkrv='docker volume ls'
alias dkrnt='docker network ls'

# daemon (dockerd) commands
alias dkrdrestart='sudo service docker restart'
alias dkrdlog='sudo journalctl -fu docker.service'
alias dkrdlogf='journalctl -fu docker _TRANSPORT=stdout + OBJECT_EXE=docker'

function dkrsh() {
	docker exec -it $1 /bin/sh
}

function dkrli() {
	docker exec -it $1 /bin/login
}

function dkrNukeContainer() {
	local name="$1"
	docker stop $(docker ps -a -q -f name="$name") 2>/dev/null
	docker rm $(docker ps -a -q -f name="$name") 2>/dev/null
}

function dkrNukeContainers() {
	for ctr in $(docker ps -a -q) ; do
		docker stop "$ctr"
		docker rm "$ctr"
	done
}

function dkrNukeImage() {
	local repository="$1"
	docker rmi $(docker images -a -q "$repository") 2>/dev/null
}

function dkrNukeImages() {
	for img in $(docker images -a -q) ; do
		docker rmi -f "$img"
	done
}

function dkrNukeVolumes() {
	for vol in $(docker volume ls -q) ; do
		docker volume rm "$vol"
	done
}

function dkrNukeAll() {
	(
		echo "- Stopping Containers..."
		for ctr in $(docker ps -a -q) ; do
			docker stop "$ctr"
		done
		docker system prune --all --force
		dkrNukeVolumes
	)
}

function dkrCleanContainers() {
	for ctr in $(docker ps -a -q -f "status=exited") ; do
		docker rm "$ctr"
	done
}

function dkrCleanImages() {
	for img in $(docker images -a -q -f "dangling=true") ; do
		docker rmi -f "$img"
	done
}

function dkrCleanVolumes() {
#	for vol in $(docker volume ls -q -f dangling=true) ; do
#		docker volume rm "$vol"
#	done
	docker volume prune --force
}

function dkrCleanAll() {
	docker system prune --force
	docker volume prune --force
}

function dkrBuildTest() {
	(
		set -xe

		# default build context is current directory
		BUILD_CTX="${BUILD_CTX:-${1:-.}}"

		# default image name is 'test'
		local defaultImageName="test_image_${PWD##*/}"
		export IMAGE_NAME="${IMAGE_NAME:-${2:-$defaultImageName}}"

		export EXEC_CMD="${EXEC_CMD:-${3:-/bin/sh}}"

		docker build --tag "$IMAGE_NAME" --force-rm "$BUILD_CTX"
		dkrRunImageIT
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
		export IMAGE_NAME="${IMAGE_NAME:-$1}"
		export EXEC_CMD="${EXEC_CMD:-${2:-/bin/sh}}"
		DKR_CMD_OPTS="$DKR_CMD_OPTS --interactive --tty"
		dkrRunImage
	)
}

function dkrRunImage() {
	: "${IMAGE_NAME:?ERROR: not set!}"
	: "${EXEC_CMD:?ERROR: not set!}"
	(
		local name="test_image"
		# turn off errors while attempting to nuke container
		set +e
		dkrNukeContainer "$name"

		(
			set -ex

			docker run \
				$DKR_CMD_OPTS \
				--name "$name" \
				"$IMAGE_NAME" \
				$EXEC_CMD
		)
	)
}

function dkrStartContainer() {
	: "${IMAGE_NAME:?ERROR: not set!}"
	(
		local name="testContainer"
		# turn off errors while attempting to nuke container
		set +e
		dkrNukeContainer "$name"

		(
			set -ex

			docker create \
				$DKR_CMD_OPTS \
				--name "$name" \
				"$IMAGE_NAME"

			docker start "$name"

			docker logs -f "$name"
		)
	)
}

if [ "$(uname)" == "Darwin" ] ; then
	function killTheWhale() {
		$(mdfind Docker.app)/Contents/MacOS/Docker --uninstall
		sudo rm -rf /Library/Containers/com.docker.*
		sudo rm -rf /Library/PrivilegedHelperTools/com.docker.vmnetd
		sudo rm -rf /Library/LaunchDaemons/com.docker.vmnetd.plist
	}

	alias dkrTTY='screen ~/Library/Containers/com.docker.docker/Data/com.docker.driver.amd64-linux/tty'
fi
