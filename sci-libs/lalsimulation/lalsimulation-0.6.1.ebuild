# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

DESCRIPTION="Simulation package of the LIGO/Virgo libraries"
HOMEPAGE="https://www.lsc-group.phys.uwm.edu/daswg/projects/lalsuite.html"
SRC_URI="https://www.lsc-group.phys.uwm.edu/daswg/download/software/source/lalsuite/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="sci-libs/lal
		sci-libs/lalmetaio
	"
RDEPEND=${DEPEND}
