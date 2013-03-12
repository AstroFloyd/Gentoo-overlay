# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

DESCRIPTION="LAL - LIGO-Virgo data-analysis software suite - pull in a coherent set of sci-libs/lal* packages"
HOMEPAGE="https://www.lsc-group.phys.uwm.edu/daswg/projects/lalsuite.html"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	=sci-libs/lal-6.9.1
	=sci-libs/lalframe-1.0.9
	=sci-libs/lalmetaio-1.0.7
	=sci-libs/lalxml-1.1.7
	=sci-libs/lalsimulation-0.6.1
	=sci-libs/lalburst-1.1.6
	=sci-libs/lalinspiral-1.4.2
	=sci-libs/lalpulsar-1.6.1
	=sci-libs/lalinference-1.0.1
	=sci-libs/lalstochastic-1.1.7
	=sci-libs/lalapps-6.11.2
"
