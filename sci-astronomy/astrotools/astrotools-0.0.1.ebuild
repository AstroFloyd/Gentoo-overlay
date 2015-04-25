# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit cmake-utils fortran-2

DESCRIPTION="Command-line tools for astronomy and astrophysics"
HOMEPAGE="http://${PN}.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="virtual/fortran
	>=sci-libs/libsufr-0.6.2
	>=sci-astronomy/libthesky-0.3.1
	"

RDEPEND="${DEPEND}"
