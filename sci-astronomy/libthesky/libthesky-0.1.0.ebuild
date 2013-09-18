# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit cmake-utils fortran-2

DESCRIPTION="Fortran library to compute positions of celestial bodies"
HOMEPAGE="http://libthesky.sourceforge.net/"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="static-libs +asteroids"

SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz
asteroids? ( mirror://sourceforge/${PN}/asteroids.dat.bz2 )"

DEPEND="virtual/fortran
>=sci-libs/libsufr-0.5.3"
RDEPEND="${DEPEND}"

src_configure() {
	mycmakeargs=(
		$(cmake-utils_use static-libs CREATE_STATICLIB)
	)
	cmake-utils_src_configure
}

src_install() {
	use asteroids && mv -vf "${WORKDIR}"/asteroids.dat "${S}"/data/
	cmake-utils_src_install
}

DOCS="CHANGELOG README VERSION"
