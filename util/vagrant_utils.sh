#!/usr/bin/env sh


pst_debug_echo "$BASH_SOURCE"

if [ -z "$(type -t vagrant)" ] ; then
	echo "It appears that the executable 'vagrant' is not in the path!"
	return
fi
echo "<<<<<<<<<< Vagrant Environment Status >>>>>>>>>>"
vagrant global-status
echo


# begin aliases and functions
alias vgprune='vagrant global-status --prune'
alias vgb='vagrant box list -i'

alias vgNukeImages="vagrant box list | cut -f 1 -d ' ' | xargs -L 1 vagrant box remove -f"

# XXX: interesting commands...
# vagrant destroy <hash>
# sudo qemu-img info vagrant_furnace.img

# TODO: i found that after destroying a Vagrant VM, there was an ISO left over
# in the libvirt directory.  Need to consider what to do with this file, as it
# should not be there.  Maybe it is just an artifact of a failed VM build?
