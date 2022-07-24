# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit cmake fortran-2

DESCRIPTION="Command-line tools for astronomy and astrophysics"
HOMEPAGE="http://${PN}.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="virtual/fortran
	>=sci-libs/libsufr-0.7.2
	>=sci-astronomy/libthesky-0.3.3
	"
RDEPEND="${DEPEND}"
