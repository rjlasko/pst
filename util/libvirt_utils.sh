#!/usr/bin/env sh


pst_debug_echo "$BASH_SOURCE"

if [ -z "$(type -t virsh)" ] ; then
	echo "It appears that the libvirt executable 'virsh' is not in the path!"
	return
fi
echo "<<<<<<<<<< Virtual Machine Status >>>>>>>>>>"
virsh list --all


# begin aliases and functions
alias lvls='virsh list'
alias lvup='virsh start'
alias lvdown='virsh shutdown'
alias lvstop='virsh destroy'
alias lvi='virsh vol-list --pool default --details'
alias qmimg='sudo qemu-img info'

# daemon (libvirtd) commands
alias lvdreset='sudo service libvirtd restart'


function lvNukeVm() {
	virsh destroy $1
	virsh undefine $1
	virsh vol-delete --pool default "$(virsh vol-list --pool default | grep $1 | awk '{print $1}')"
	# TODO: snapshots
}


function lvNukeVms() {
	for vm in $(virsh list --all | tail -n +3 | awk '{print $2}') ; do
		lvNukeVm $vm
	done
}

function lvNukeVols() {
	for vol in $(virsh vol-list --pool default | tail -n +3 | awk '{print $1}') ; do
		virsh vol-delete --pool default $vol;
	done;
}

function lvNukeSnaps() {
	for vm in $(virsh list --all | tail -n +3 | head -n +1 | cut -d' ' -f7) ; do
		for snapshot in $(virsh snapshot-list $vm | tail -n +3 | head -n -1 | cut -d' ' -f2) ; do
			virsh snapshot-delete $vm $snapshot;
		done;
	done
}
