# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit fortran-2

DESCRIPTION="A Fortran interface to the GNU Scientific Library"
HOMEPAGE="http://www.lrz.de/services/software/mathematik/gsl/fortran/"
SRC_URI="http://www.lrz.de/services/software/mathematik/gsl/fortran/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~amd64-linux"
IUSE="doc-html doc-pdf examples static-libs"

RDEPEND=">=sci-libs/gsl-1.13
		 <sci-libs/gsl-2"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

FORTRAN_STANDARD=2003

MAKEOPTS="-j1"  # fgsl.mod cannot be built in parallel

src_configure() {
	econf $(use_enable static-libs static)
}

src_install() {
	dolib.so .libs/*.so .libs/*.so.*
	dolib libfgsl.la
	use static-libs && dolib.a .libs/*.a

	insinto /usr/include/fgsl
	doins fgsl.mod

	dodoc NEWS README
	use doc-html && dodoc -r doc/html/          # ~11Mb
	use doc-pdf  && dodoc doc/latex/refman.pdf  # ~4.6Mb
	use examples && dodoc -r doc/examples/      # ~300kb (zipped)
}
