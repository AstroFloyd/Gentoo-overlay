# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
CMAKE_VERBOSE=1

inherit cmake fortran-2

DESCRIPTION="Simple command-line tools for working with gravitational waves"
HOMEPAGE="http://${PN}.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="virtual/fortran
	>=sci-libs/libsufr-0.6.1
	"
RDEPEND=${DEPEND}
