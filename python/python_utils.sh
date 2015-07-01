#!/bin/sh


pst_debug_echo "$BASH_SOURCE"

if [ -z "$(command -v python 2>/dev/null)" ] ; then
	echo "It appears that the Python executable 'python' is not in the path!"
	return
fi

alias pst_python="PYTHONPATH=$PST_ROOT/python:$PYTHONPATH python"