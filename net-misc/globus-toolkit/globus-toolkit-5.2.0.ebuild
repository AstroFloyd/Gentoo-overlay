# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
MY_PN=gt
MY_P=${MY_PN}${PV}"-all-source-installer"

DESCRIPTION="An open source software toolkit used for building grids."
HOMEPAGE="http://www.globus.org/toolkit/"
SRC_URI="http://www.globus.org/ftppub/gt5/5.2/${PV}/installers/src/${MY_P}.tar.gz"

LICENSE="Mixed"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=" "

DEPEND=""
RDEPEND="${DEPEND}"


S=${WORKDIR}/${MY_P}

src_configure() {
	einfo "Configuring..."
	#cd ${S}
	#./configure --prefix=${WORKDIR}/usr/local/globus-${PV}
	./configure --prefix=${WORKDIR}/install/
}

# Note: 'make' also does (most of) 'make install' (!)
src_compile() {
	einfo "Compiling..."
	#make gpt  # Build gpt(-build) before anything else
	#make

	#make -j1   # Running make in parallel may cause problems

	#LSC stuff only:
	make -j1 gpt  # Running make in parallel may cause problems
	make -j1 globus_proxy_utils globus_gsi_cert_utils  # Running make in parallel may cause problems
	# PROBLEM: sshd is installed in /usr/sbin/...
}

src_install() {
	einfo "Installing..."
	#make install gpt  # Build gpt(-build) before anything else
	#make

	make -j1 install gpt globus_proxy_utils globus_gsi_cert_utils
	#MY_D=${D}usr/local/globus-${PV}/
	MY_D=${D}usr/
	mkdir -pv ${MY_D}
	cp -rv ${WORKDIR}/install/* ${MY_D}
}

