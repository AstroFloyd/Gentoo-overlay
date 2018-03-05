# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit rpm

DESCRIPTION="National Instruments DAQ MX base drivers"
HOMEPAGE="http://www.ni.com/download/ni-daqmx-base-14.0/5054/en/"
SRC_URI="nidaqmxbase-board-support-14.0.0-f0.i386.rpm nidaqmxbase-cinterface-14.0.0-f0.i386.rpm nidaqmxbase-common-14.0.0-f0.i386.rpm nidaqmxbase-usb-support-14.0.0-f0.i386.rpm"

LICENSE="NILICENSE"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc examples"

RESTRICT="fetch"

S="${WORKDIR}/usr/local/natinst/nidaqmxbase"

pkg_nofetch() {
	einfo "Go to http://www.ni.com/download/ni-daqmx-base-14.0/5054/en/ and register"
	einfo "  in order to download and mount the .iso file."
	einfo "  Then copy the following rpms to /usr/portage/distfiles/"
	einfo "    nidaqmxbase-common-14.0.0-f0.i386.rpm"
	einfo "    nidaqmxbase-board-support-14.0.0-f0.i386.rpm"
	einfo "    nidaqmxbase-usb-support-14.0.0-f0.i386.rpm"
	einfo "    nidaqmxbase-cinterface-14.0.0-f0.i386.rpm"
	echo
}

src_install() {
	rm -rf bin/support
	(use doc || use examples) && mkdir -p "share/${PN}"
	use doc && mv documentation "share/${PN}/doc"
	use examples && mv examples "share/${PN}/"

	dobin "${S}"/bin/*
	dolib lib/*
	insinto usr/include/
	doins include/*
	insinto etc/
	doins -r etc/*
	insinto usr/
	(use doc || use examples) && doins -r share
}
