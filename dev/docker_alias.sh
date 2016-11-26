#!/bin/sh


pst_debug_echo "$BASH_SOURCE"

if [ -z "$(command -v docker 2>/dev/null)" ] ; then
	echo "It appears that the docker executable 'docker' is not in the path!"
	return
fi

alias docker='sudo docker'
alias dkri="docker images -a"
alias dkrps='docker ps -a'
alias dkrv='docker volume ls'

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
