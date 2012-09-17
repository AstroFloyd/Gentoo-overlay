# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
CMAKE_VERBOSE=1

inherit cmake-utils fortran-2

DESCRIPTION="Tools to manipulate and display output from the binary stellar-evolution code ev/TWIN"
HOMEPAGE="http://${PN}.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"


LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="virtual/fortran
	sci-libs/pgplot
	sci-libs/libsufr
	"
	
RDEPEND="${DEPEND}"

