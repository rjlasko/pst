#!/bin/sh


pst_debug_echo "$BASH_SOURCE"

if [ -n "$(type -t virsh)" ] ; then
	echo "<<<<<<<<<< Virtual Machine Status >>>>>>>>>>"
	export LIBVIRT_DEFAULT_URI='qemu:///system'
	virsh list --all
else
	echo "It appears that the libvirt executable 'virsh' is not in the path!"
	return
fi