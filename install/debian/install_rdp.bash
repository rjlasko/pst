#!/bin/bash
set -ueo pipefail
#set -xv

SCRIPT_ROOT=$(cd $(dirname "$BASH_SOURCE") ; pwd -P)
SCRIPT_NAME=$(basename "${BASH_SOURCE[0]}")
echo -e "\n${USER}@$(hostname) running: ${SCRIPT_ROOT}/${SCRIPT_NAME} $@"

## -------------------------------------------------------- ##
## This script seeks to automate the installation of a XRDP ##
## -------------------------------------------------------- ##
# https://wiki.archlinux.org/index.php/xrdp

read -p "Install XRDP using APT? y/N : " xrdp_apt
xrdp_apt=${xrdp_apt:-N}
if [ "y" == $(echo "${xrdp_apt}" | tr 'Y' 'y') ] ; then
	apt-get install -y xrdp
else
	
# XXX: Here is a (slightly modified) copy of the instructions found at:
# https://github.com/neutrinolabs/xrdp/wiki/Building-on-Debian-8

# XXX: the installation from the v0.9.9 source is necessary to support a graphical feature
#      required by the MacOS version of the Microsoft Remote Desktop application
#      https://github.com/neutrinolabs/xrdp/pull/1235

	apt-get install -y \
		git autoconf libtool pkg-config gcc g++ make \
		libssl-dev libpam0g-dev libjpeg-dev libx11-dev libxfixes-dev libxrandr-dev \
		flex bison libxml2-dev intltool xsltproc xutils-dev python-libxml2 \
		g++ xutils libfuse-dev libmp3lame-dev nasm libpixman-1-dev \
		xserver-xorg-dev
	
	# Get sources from the release page, or clone xrdp and xorgxrdp repository from GitHub if you need the devel branch:
	BD=$(mktemp -d)
	mkdir -p "${BD}"/git/neutrinolabs
	cd "${BD}"/git/neutrinolabs
	wget https://github.com/neutrinolabs/xrdp/releases/download/v0.9.9/xrdp-0.9.9.tar.gz
	wget https://github.com/neutrinolabs/xorgxrdp/releases/download/v0.2.9/xorgxrdp-0.2.9.tar.gz
	
	# Build and install xrdp server (Adapt the configure line to activate your needed features)
	cd "${BD}"/git/neutrinolabs
	tar xvfz xrdp-0.9.9.tar.gz
	cd "${BD}"/git/neutrinolabs/xrdp-0.9.9
	./bootstrap
	./configure --enable-fuse --enable-mp3lame --enable-pixman
	make
	make install
	ln -s /usr/local/sbin/xrdp{,-sesman} /usr/sbin
	
	# Build and install xorgxrdp
	cd "${BD}"/git/neutrinolabs
	tar xvfz xorgxrdp-0.2.9.tar.gz
	cd "${BD}"/git/neutrinolabs/xorgxrdp-0.2.9
	./bootstrap
	./configure
	make
	make install
fi

# TODO: additional XRDP configuration
# XXX: 'man xrdp.ini', as in /etc/xrdp/xrdp.ini
# XXX: 'man sesman.ini', as in /etc/xrdp/sesman.ini

# allows anybody to start X. Necessary to run XRDP as a terminal server (Xorg).  default is 'console'
sed -i '/^allowed_users/c\allowed_users=anybody' /etc/X11/Xwrapper.config

# TODO: Generate certificate /etc/xrdp/{cert,key}.pem if you don't want to use the self-signed certificate

systemctl restart xrdp.service
systemctl enable xrdp.service
systemctl restart xrdp-sesman.service
systemctl enable xrdp-sesman.service

