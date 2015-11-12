#!/bin/sh


pst_debug_echo "$BASH_SOURCE"

if [ -z "$(command -v python 2>/dev/null)" ] ; then
	echo "It appears that the Python executable 'python' is not in the path!"
	return
fi

alias pst_python="PYTHONPATH=$PST_ROOT/python:$PST_ROOT/python/pylib:$PST_ROOT/bin:$PYTHONPATH python"
alias pst_python_sudo='sudo pst_python'


function pst_wol() {
	pst_python -c "import toolkit; toolkit.wakeHost(\"$1\", \"$2\")"
}

function pst_myifips() {
	pst_python -c "import toolkit; toolkit.getInterfaceIPs()"
}

function pst_myips() {
	pst_python -c "import toolkit; toolkit.getLocalIps()"
}
# XXX: an override for the alias in common_utils.sh
alias myip=pst_myips
