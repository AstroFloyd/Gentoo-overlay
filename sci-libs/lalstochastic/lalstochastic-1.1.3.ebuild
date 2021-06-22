# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Stochastic-background package of the LIGO/Virgo libraries."
HOMEPAGE="https://wiki.ligo.org/Computing/LALSuite"
SRC_URI="https://software.igwn.org/sources/source/lalsuite/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="=sci-libs/lal-6.6.1-r0
		=sci-libs/lalmetaio-1.0.3-r0
	"
RDEPEND=${DEPEND}
