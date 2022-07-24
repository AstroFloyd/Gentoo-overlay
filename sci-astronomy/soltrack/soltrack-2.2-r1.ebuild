# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
CMAKE_MAKEFILE_GENERATOR=emake
inherit cmake

DESCRIPTION="A simple, free, fast and accurate routine to compute the position of the Sun"
HOMEPAGE="http://soltrack.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="static-libs"

DEPEND=""
RDEPEND="${DEPEND}"

src_configure() {
	mycmakeargs=(
		-DCREATE_STATICLIB="$(usex static-libs)"
	)
	cmake_src_configure
}
