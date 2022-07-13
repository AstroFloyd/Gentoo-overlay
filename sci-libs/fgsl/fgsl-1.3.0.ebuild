# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit fortran-2

DESCRIPTION="A Fortran interface to the GNU Scientific Library"
HOMEPAGE="https://doku.lrz.de/display/PUBLIC/FGSL+-+A+Fortran+interface+to+the+GNU+Scientific+Library"
SRC_URI="https://doku.lrz.de/download/attachments/43321199/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~amd64-linux"
IUSE="doc-html examples static-libs"

RDEPEND=">=sci-libs/gsl-2.4"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

FORTRAN_STANDARD=2003
MAKEOPTS="-j1"  # fgsl.mod cannot be built in parallel

src_configure() {
	econf $(use_enable static-libs static)
}

src_install() {
	dolib.so .libs/*.so .libs/*.so.*
	use static-libs && dolib.a libfgsl.la
	use static-libs && dolib.a .libs/*.a

	insinto /usr/include/fgsl
	doins fgsl.mod

	dodoc NEWS README
	use doc-html && dodoc -r doc/html/      # ~9Mb
	# use doc-pdf  && dodoc doc/refman.pdf    # not available in v1.3(!)
	use examples && dodoc -r doc/examples/  # ~0.3Mb (zipped)
}
