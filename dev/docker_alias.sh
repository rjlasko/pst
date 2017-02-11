#!/bin/sh


pst_debug_echo "$BASH_SOURCE"

if [ -z "$(type -t docker)" ] ; then
	echo "It appears that the docker executable 'docker' is not in the path!"
	return
fi

alias docker='sudo docker'
alias docker-compose='sudo docker-compose'
alias dkrcmp='docker-compose'
alias dkri="docker images -a"
alias dkrps='docker ps -a'
alias dkrv='docker volume ls'

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
	docker stop $(docker ps -a -q) 2>/dev/null
	docker rm $(docker ps -a -q) 2>/dev/null
}

function dockerNukeImage() {
	local repository="$1"
	docker rmi $(docker images -a -q "$repository") 2>/dev/null
}

function dockerNukeImages() {
	docker rmi $(docker images -a -q) 2>/dev/null
}

function dockerNukeVolumes() {
	docker volume rm $(docker volume ls -qf dangling=true)
}

function dockerNukeAll() {
	dockerNukeContainers
	dockerNukeImages
	dockerNukeVolumes
}
