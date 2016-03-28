# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="Man pages for the Fortran language"
HOMEPAGE="https://github.com/AstroFloyd/man-pages-fortran"
SRC_URI="https://github.com/AstroFloyd/man-pages-fortran/releases/download/v${PV}/${P}.tar.gz"

LICENSE="FDL-1.3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND=""
RDEPEND="virtual/man"

src_install() {
	dodoc README.md CHANGELOG VERSION
	doman man3f/*.3f
	mv -f "${D}/usr/share/man/man3" "${D}/usr/share/man/man3f"
	doman man3f/fortran.3f
}
