
#!/bin/sh


pst_debug_echo "$BASH_SOURCE"

if [ -z "$(command -v docker 2>/dev/null)" ] ; then
	echo "It appears that the docker executable 'docker' is not in the path!"
	return
fi

alias docker='sudo docker'
alias dkri="docker images"
alias dkrps='docker ps -a'

function dkrsh() {
	docker exec -it $1 /bin/bash
}

function dkrli() {
	docker exec -it $1 /bin/login
}
