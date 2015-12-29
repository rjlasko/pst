#!/bin/sh


pst_debug_echo "$BASH_SOURCE"

if [ -z "$(command -v python 2>/dev/null)" ] ; then
	echo "It appears that the Python executable 'python' is not in the path!"
	return
fi

alias pst_pythonpath="PYTHONPATH=$PST_ROOT/python:$PST_ROOT/python/pylib:$PST_ROOT/python/bin:$PYTHONPATH"
alias pst_python="pst_pythonpath python"
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

function pst_easy_install() {
    install_lib="$PST_ROOT/python/pylib"
    mkdir -p "$install_lib"
    install_scripts="$PST_ROOT/python/bin"
    mkdir -p "$install_scripts"
	cfg_file=$HOME/.pydistutils.cfg
	echo "[install]" > $cfg_file
	echo "install_lib=$install_lib" >> $cfg_file
	echo "install_scripts=$install_scripts" >> $cfg_file
	pst_pythonpath easy_install $@
	rm $cfg_file
	rm -rf "$HOME/.python-eggs"
}



# TODO: need a cygwin-specific install of easy-install

# TODO: turn the wol package into an egg with easy-install
