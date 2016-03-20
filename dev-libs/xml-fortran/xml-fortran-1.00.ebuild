# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit fortran-2

DESCRIPTION="Library and programs to access XML-files in Fortran"
HOMEPAGE="http://xml-fortran.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="virtual/fortran"
RDEPEND="${DEPEND}"

IUSE="static-libs doc examples"
S="${WORKDIR}/${PN}/"

src_configure() {
	cp "${FILESDIR}/makefile" src/
}

src_compile() {
	cd src/
	make -j1 || die
}

src_install() {
	cd src/
	#dobin xmlreader
	#dobin tstparse

	dolib.so libxmlparse.so
	use static-libs && dolib.a libxmlparse.a
	insinto "usr/include/${PN}"
	doins xmlparse.mod

	cd ..
	dodoc CHANGES TODO
	use doc && dodoc doc/*.pdf
	use doc && dohtml doc/*.html
	docinto examples/
	use examples && dodoc examples/*
}
