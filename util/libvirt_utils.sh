#!/usr/bin/env sh


pst_debug_echo "$BASH_SOURCE"

if [ -z "$(type -t virsh)" ] ; then
	echo "It appears that the libvirt executable 'virsh' is not in the path!"
	return
fi
echo "<<<<<<<<<< Virtual Machine Status >>>>>>>>>>"
virsh list --all


# begin aliases and functions
alias lvls="virsh list"
alias lvstart="virsh start"
alias lvdown="virsh shutdown"
alias lvstop="virsh destroy"
alias lvi="virsh vol-list default --details"

function lvrm() {
	local vm_image_path="$(virsh vol-list default | grep $1 | awk '{print $2}')"
	virsh undefine $1
	rm -f "${vm_image_path}"
	sudo service libvirtd restart
}

function lvreset() {
	sudo service libvirtd restart
}

function lvNukeVms() {
	for vm in $(virsh list --all | tail -n +3 | awk '{print $2}') ; do
		virsh destroy $vm
		virsh undefine $vm
	done
}

function lvNukeVols() {
	for vm in $(virsh list --all | tail -n +3 | head -n +1 | cut -d' ' -f7) ; do
		for vol in $(virsh vol-list $vm | tail -n +3 | head -n -1 | cut -d' ' -f2) ; do
			virsh vol-delete $vm $vol;
		done;
	done
}

function lvNukeSnaps() {
	for vm in $(virsh list --all | tail -n +3 | head -n +1 | cut -d' ' -f7) ; do
		for snapshot in $(virsh snapshot-list $vm | tail -n +3 | head -n -1 | cut -d' ' -f2) ; do
			virsh snapshot-delete $vm $snapshot;
		done;
	done
}
