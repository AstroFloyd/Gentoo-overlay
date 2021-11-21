# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

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
	sed -i "s|^FOPT.*|& ${FCFLAGS}|" src/makefile
	sed -i "s|^\t\${FC} -shared |& ${LDFLAGS} |" src/makefile
}

src_compile() {
	cd src/
	emake -j1 || die
}

src_install() {
	cd src/
	# dobin xmlreader
	# dobin tstparse

	dolib.so libxmlparse.so
	use static-libs && dolib.a libxmlparse.a
	insinto "usr/include/${PN}"
	doins xmlparse.mod

	cd ..
	dodoc CHANGES TODO
	use doc && dodoc doc/*.pdf doc/*.html
	docinto examples/
	use examples && dodoc examples/*
}
