# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit cmake-utils fortran-2

DESCRIPTION="Plot the key stages in the evolution of a binary star"
HOMEPAGE="http://rocheplot.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="virtual/fortran
	sci-libs/pgplot
	>=sci-libs/libsufr-0.6.4
	"
RDEPEND="${DEPEND}"
