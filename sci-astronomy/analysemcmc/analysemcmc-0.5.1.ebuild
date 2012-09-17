# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
CMAKE_VERBOSE=1

inherit cmake-utils fortran-2

DESCRIPTION="Analyse output from the gravitational-wave data-analysis code SPINspiral"
HOMEPAGE="http://${PN}.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"


LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="virtual/fortran
	|| ( sci-libs/pgplot  sci-libs/plplot )
	sci-libs/libsufr
	"
	
RDEPEND="${DEPEND}
	media-gfx/imagemagick
	app-text/a2ps
	"


src_install() {
    # Install binary:
    cmake-utils_src_install || die "install failed"
    
    # Install documentation:
    dodoc INSTALL README VERSION LICENCE analysemcmc.dat || die "installing doc failed"
}