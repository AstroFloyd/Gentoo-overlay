# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="A graphical GPS data manager that supports several devices."
SRC_URI="mirror://sourceforge/${PN}/${P}.tgz"
HOMEPAGE="http://gpsman.sourceforge.net/"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc utils"

DEPEND=""

RDEPEND=">=dev-lang/tcl-8.4
	>=dev-lang/tk-8.4"

GMDIR="/usr/share/gpsman"

src_prepare() {
	# Set proper GM path:
	sed -i -e "s:gmsrc:${GMDIR}/gmsrc:" gpsman.tcl
}

src_install() {
	newbin gpsman.tcl gpsman

	dodir ${GMDIR}/gmsrc
	insinto ${GMDIR}/gmsrc
	doins -r gmsrc/*

	doman man/man1/gpsman.1

	if use utils
	then
		dodir ${GMDIR}/util
		exeinto ${GMDIR}/util
		doexe util/*
	fi

	if use doc
	then
		dodoc manual/GPSMandoc.pdf
		dohtml -r manual/html/*
	fi
}

pkg_info() {
	einfo "Support for the Garmin USB protocal requires a"
	einfo "kernel >= version 2.6.11 and the USB_SERIAL_GARMIN"
	einfo "option set."
	use doc && einfo "See /usr/share/doc/${P}/ for more info."
}
