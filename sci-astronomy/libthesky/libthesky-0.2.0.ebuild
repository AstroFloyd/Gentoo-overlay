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
IUSE="static-libs"

SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz
mirror://sourceforge/${PN}/libthesky-data-20131020.tar.bz2"

DEPEND="virtual/fortran
>=sci-libs/libsufr-0.5.4"
RDEPEND="${DEPEND}"

src_configure() {
	mycmakeargs=(
		$(cmake-utils_use static-libs CREATE_STATICLIB)
	)
	cmake-utils_src_configure
}

# CMake cannot build Fortran codes in parallel:
src_compile() {
	cd "${CMAKE_BUILD_DIR}"
	emake -j1 || die
}

src_install() {
	insinto /usr/share/libTheSky
	doins "${WORKDIR}"/data/*
	cmake-utils_src_install
}

DOCS="CHANGELOG README VERSION"
