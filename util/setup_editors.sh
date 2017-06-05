#!/bin/sh
set -e

if [ -n "$(type -t vim)" ] ; then
	echo '" Installed via PST' > "$HOME/.vimrc"
	echo 'syntax on' >> "$HOME/.vimrc"
	echo 'set noswapfile' >> "$HOME/.vimrc"
else
	echo "vim is not installed!" 1>&2
fi

if [ -n "$(type -t nano)" ] ; then
	echo '# Installed via PST' > "$HOME/.nanorc"
	find /usr -iname "*.nanorc" -print0 2>/dev/null | xargs -0 -n1 echo "include" >> "$HOME/.nanorc"
	echo "set smooth" >> "$HOME/.nanorc"
	echo "set autoindent" >> "$HOME/.nanorc"
	echo "set tabsize 4" >> "$HOME/.nanorc"
else
	echo "nano is not installed!" 1>&2
fi
