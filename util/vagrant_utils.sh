#!/usr/bin/env sh


pst_debug_echo "$BASH_SOURCE"

if [ -z "$(type -t vagrant)" ] ; then
	echo "It appears that the executable 'vagrant' is not in the path!"
	return
fi
export VAGRANT_HOME="/zDisk/vm/vagrant"
echo "<<<<<<<<<< Docker Container Status >>>>>>>>>>"
vagrant global-status
echo

# begin aliases and functions
# XXX: interesting commands...
# vagrant global-status --prune
# vagrant destroy <hash>


# TODO: i found that after destroying a Vagrant VM, there was an ISO left over
# in the libvirt directory.  Need to consider what to do with this file, as it
# should not be there.  Maybe it is just an artifact of a failed VM build?
