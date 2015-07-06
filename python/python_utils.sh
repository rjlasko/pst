#!/bin/sh


pst_debug_echo "$BASH_SOURCE"

if [ -z "$(command -v python 2>/dev/null)" ] ; then
	echo "It appears that the Python executable 'python' is not in the path!"
	return
fi

alias pst_python="PYTHONPATH=$PST_ROOT/python:$PYTHONPATH python"
alias pst_python_sudo="sudo PYTHONPATH=$PST_ROOT/python:$PYTHONPATH python"


function pst_wol() {
	PYTHONPATH=$PST_ROOT/python python -c "import toolkit; toolkit.wakeHost(\"$1\", \"$2\")"
}

function myip() {
	PYTHONPATH=$PST_ROOT/python python -c "import toolkit; toolkit.getLocalIp()"
}