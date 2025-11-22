# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CMAKE_MAKEFILE_GENERATOR="emake"
CMAKE_BUILD_TYPE=Release
inherit cmake fortran-2

DESCRIPTION="Fortran library to compute positions of celestial bodies"
HOMEPAGE="http://libthesky.sourceforge.net/"
SRC_URI="https://downloads.sourceforge.net/${PN}/${P/_p*}.tar.gz
https://downloads.sourceforge.net/${PN}/libthesky-data-20160409.tar.bz2
"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="static-libs"

DEPEND=">=sci-libs/libsufr-0.7.7[static-libs?]"
RDEPEND="${DEPEND}"

src_unpack() {
	default

	gunzip -r "${S}"/man || die

	mv "${WORKDIR}"/data "${S}" || die
}

# src_prepare() {
# 	eapply_user

# 	# Doc dir should have revision number:
# 	sed -i 's|share/doc/libthesky-\${PKG_VERSION}|share/doc/${PN}|g' "${WORKDIR}/CMakeLists.txt"
# }

src_configure() {
	local mycmakeargs=(
		-DCMAKE_VERBOSE_MAKEFILE=ON
		-DCREATE_SHAREDLIB=ON
		-DCREATE_STATICLIB=$(usex static-libs)
		-DCMAKE_INSTALL_DOCDIR="/usr/share/doc/${PN}"
	)
	cmake_src_configure
}
