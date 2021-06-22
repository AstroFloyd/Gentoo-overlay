# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="LAL - LIGO-Virgo data-analysis software suite"
HOMEPAGE="https://wiki.ligo.org/Computing/LALSuite"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	=sci-libs/lal-6.9.1-r0
	=sci-libs/lalframe-1.0.9-r0
	=sci-libs/lalmetaio-1.0.7-r0
	=sci-libs/lalsimulation-0.6.1-r0
	=sci-libs/lalburst-1.1.6-r0
	=sci-libs/lalinspiral-1.4.2-r0
	=sci-libs/lalpulsar-1.6.1-r0
	=sci-libs/lalinference-1.0.1-r0
	=sci-libs/lalstochastic-1.1.7-r0
	=sci-libs/lalapps-6.11.2-r0
"
#	=sci-libs/lalxml-1.1.7  # compatible, but unused
