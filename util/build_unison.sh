#!/usr/bin/env bash
set -xueo pipefail

# This script will build the Unison File Synchronizer.
# https://www.cis.upenn.edu/~bcpierce/unison/
# https://www.cis.upenn.edu/~bcpierce/unison/download/releases/stable/unison-manual.html
#
# Unison has a version specific build dependence on Objective Caml, so OCaml will also be built as part of this installation.
#
# The following environment variables must be defined:
# UNISON_VERSION (ex. 2.51.2)
# OCAML_VERSION (ex. 4.06.1)
#
# And the following binaries must be installed: gcc (with GLIBC), make, curl, tar, cut


# Helper function that will derive the Major/Minor version from a given version
# Example getMinorVersion 1.2.3 = 1.2
function getMinorVersion() {
	echo $1 | cut -f1,2 -d'.'
}

# derive the minor version number of OCaml
OCAML_MINOR_VERSION=$(getMinorVersion $OCAML_VERSION)

# Define binary output directory
DEST_BIN_DIR="${HOME}/bin"


###########################################
# Download, Extract & Verify Source Files #
###########################################
WORK_BASE=$(mktemp -d)
WORK_SRC="${WORK_BASE}/src"

# OCaml
OCAML_EXTRACT_DIR="${WORK_SRC}/ocaml"
mkdir -p ${OCAML_EXTRACT_DIR}
OCAML_SRC_DIR="${OCAML_EXTRACT_DIR}/ocaml-${OCAML_VERSION}"
curl -L http://caml.inria.fr/pub/distrib/ocaml-${OCAML_MINOR_VERSION}/ocaml-${OCAML_VERSION}.tar.gz | tar zx -C ${OCAML_EXTRACT_DIR}
if [ ! -d "${OCAML_SRC_DIR}" ] ; then
	echo "Expected OCAML source directory not found: ${OCAML_SRC_DIR}" 1>&2
	exit -1
fi

# Unison
UNISON_EXTRACT_DIR="${WORK_SRC}/unison"
mkdir -p ${UNISON_EXTRACT_DIR}
# as of 2.48.4
UNISON_SRC_DIR="${UNISON_EXTRACT_DIR}/src"
curl -L http://www.seas.upenn.edu/~bcpierce/unison/download/releases/unison-${UNISON_VERSION}/unison-${UNISON_VERSION}.tar.gz | tar zx -C ${UNISON_EXTRACT_DIR}
if [ ! -d "${UNISON_SRC_DIR}" ] ; then
	echo "Expected Unison source directory not found: ${UNISON_SRC_DIR}" 1>&2
	exit -1
fi


#################
# Install OCaml #
#################
OCAML_INSTALL_DIR="${WORK_BASE}/ocaml"

chmod -R 0777 ${OCAML_SRC_DIR}/*
cd "${OCAML_SRC_DIR}"
./configure -prefix "${OCAML_INSTALL_DIR}" -with-pthread -no-graph -no-debugger -no-ocamldoc
make world.opt install

# put on path
if [ ! -d "${OCAML_INSTALL_DIR}/bin" ] ; then
	echo "Expected OCAML binaries not found: ${OCAML_INSTALL_DIR}" 1>&2
	exit -1
fi
export PATH=${OCAML_INSTALL_DIR}/bin:$PATH


##################
# Install Unison #
##################
cd ${UNISON_SRC_DIR}
if [ "$(uname)" == "Darwin" ] ; then
	# to address "was built for newer OSX version" issue
	# credit goes to Katrina Ellison Geltman
	# see: http://katrinaeg.com/unison-el-capitan.html
	OSX_VERSION=$(sw_vers -productVersion)
	OSX_MINOR_VERSION=$(getMinorVersion $(sw_vers -productVersion))
	sed -i -e 's/MINOSXVERSION=10.5/MINOSXVERSION='${OSX_MINOR_VERSION}'/' ./Makefile.OCaml
fi
make UISTYLE=text THREADS=true
mkdir -p ${DEST_BIN_DIR}
cp -f ${UNISON_SRC_DIR}/unison ${DEST_BIN_DIR}/

echo "Unison ${UNISON_VERSION} has been installed to: ${DEST_BIN_DIR}"


###########
# Cleanup #
###########
rm -rf ${WORK_BASE}
