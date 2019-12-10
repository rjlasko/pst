#!/usr/bin/env sh


pst_debug_echo "$BASH_SOURCE"

if [ -n "$(type -t virsh)" ] ; then
	echo "<<<<<<<<<< Virtual Machine Status >>>>>>>>>>"
	export LIBVIRT_DEFAULT_URI='qemu:///system'
	virsh list --all
else
	echo "It appears that the libvirt executable 'virsh' is not in the path!"
	return
fi

alias vmls="virsh list"
alias vmstart="virsh start"
alias vmdown="virsh shutdown"
alias vmstop="virsh destroy"

function vmrm() {
	local vm_image_path="$(virsh vol-list default | grep $1 | awk '{print $2}')"
	virsh undefine $1
	rm -f "${vm_image_path}"
}
