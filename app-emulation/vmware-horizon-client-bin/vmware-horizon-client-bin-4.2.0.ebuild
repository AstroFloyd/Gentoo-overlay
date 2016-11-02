# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

DESCRIPTION="Binary version of VMware horizon client"
HOMEPAGE="https://my.vmware.com/web/vmware/info/slug/desktop_end_user_computing/vmware_horizon_clients/4_0"
SRC_URI="https://download3.vmware.com/software/view/viewclients/CART16Q3/VMware-Horizon-Client-4.2.0-4329640.x64.bundle"

LICENSE="vmware"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND=""
RDEPEND=""

src_unpack() {
	mkdir ${S}  # No unpacking to be done, but dir must exists for src_prepare()
}

src_prepare() {
	cp ${DISTDIR}/${A} ${S}  # Copy the distfile to the source dir
	chmod +x ${S}/${A}       # Make the distdir executable
}

src_compile() {
	#TERM=dumb VMWARE_EULAS_AGREED=yes \
	#	./${A} --console \
	#	--set-setting vmware-horizon-usb usbEnable yes \
	#	--set-setting vmware-horizon-virtual-printing tpEnable yes \
	#	--set-setting vmware-horizon-smartcard smartcardEnable no\
	#	--set-setting vmware-horizon-rtav rtavEnable no \
	#	--set-setting vmware-horizon-tsdr tsdrEnable yes \
	#	--set-setting vmware-horizon-mmr mmrEnable no  ||  die  'Compilation (unpacking) failed'

	./${A} -x extract/
}

src_install() {
	# Following the Arch Linux package build for v4.1.0

	# Client:
	cd ${S}/extract/vmware-horizon-client/
	dobin bin/*
	exeinto usr/lib/vmware/view/bin/
	doexe lib/vmware/view/bin/vmware-view
	insinto usr/share
	doins -r share/*
	dodoc doc/*
	dodoc debug/*

	# PCOIP:
	cd ${S}/extract/vmware-horizon-pcoip/pcoip/
	dobin bin/*
	insinto usr/lib/
	doins -r lib/*

	# Real-time audio/video:
	cd ${S}/extract/vmware-horizon-rtav/
	insinto usr/lib/
	doins -r lib/*

	# Smartcard:
	cd ${S}/extract/vmware-horizon-smartcard/
	insinto usr/lib/
	doins -r lib/*

	# USB redirection:
	cd ${S}/extract/vmware-horizon-usb/
	exeinto usr/lib/vmware/view/usb/
	doexe bin/*
	# Note: no init scripts

	# Virtual printing:
	cd ${S}/extract/vmware-horizon-virtual-printing/
	exeinto usr/lib/vmware/view/usb/
	doexe bin/*
	dobin bin/x86_64-linux-NOSSL/thnu*  # Specific for amd64
	exeinto etc/thnuclnt/
	doexe bin/x86_64-linux-NOSSL/.thnumod  # Specific for amd64
	exeinto usr/lib/vmware/rdpvcbridge/
	doexe lib/tprdp.so
	insinto usr/share/cups/mime/
	doins bin/conf/thnuclnt.convs bin/conf/thnuclnt.types
	# Note: no Arch service file
}

pkg_postinst() {
	ewarn "This is an experimental ebuild.  Use at your own risk!"
}
