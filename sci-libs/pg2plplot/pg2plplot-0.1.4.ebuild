# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
CMAKE_VERBOSE=1

inherit cmake-utils fortran-2

DESCRIPTION="Assist the transition from PGPlot to PLplot in Fortran programs"
HOMEPAGE="http://${PN}.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="virtual/fortran
	sci-libs/libsufr
	"
RDEPEND=${DEPEND}

src_configure() {
	mycmakeargs=(
		$(cmake-utils_use static-libs CREATE_STATICLIB)
	)
	cmake-utils_src_configure
}

src_install() {
    # Install binary:
    cmake-utils_src_install || die "install failed"
    
    # Install documentation:
    dodoc CHANGELOG INSTALL LICENCE README VERSION || die "installing doc failed"
}
