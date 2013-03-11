# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

DESCRIPTION="LAL - LIGO-Virgo data-analysis software - pull in a coherent set of sci-libs/lal* packages"
HOMEPAGE="https://www.lsc-group.phys.uwm.edu/daswg/projects/lalsuite.html"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	=sci-libs/lalapps-6.6.2
	=sci-libs/lalburst-1.1.1
	=sci-libs/lalinference-0.1.1
	=sci-libs/lalinspiral-1.2.0
	=sci-libs/lalpulsar-1.2.1
	=sci-libs/lalstochastic-1.1.3
"
