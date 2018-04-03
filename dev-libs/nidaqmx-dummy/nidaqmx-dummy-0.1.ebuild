# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

DESCRIPTION="Dummy library to compile and link code using NI DAQmx under Linux"
HOMEPAGE="http://doesntexist.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="static-libs"

RDEPEND="${DEPEND}"

S=${WORKDIR}

pkg_nofetch() {
	ewarn "A source tarball for this package is not available, because it is based on propriatory NI code."
	ewarn "Please send astrofloyd [at] gmail a message if you're interested."
}

src_prepare() {
	cp etc/Makefile .
}

src_install() {
	doheader src/nidaqmx-dummy.h
	dolib libnidaqmx-dummy.so
	use static-libs && dolib libnidaqmx-dummy.a
}

pkg_info() {
	ewarn "A source tarball for this package is not available, because it is based on propriatory NI code."
	ewarn "Please send astrofloyd [at] gmail a message if you're interested."
}
