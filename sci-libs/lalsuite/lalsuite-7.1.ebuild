# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="LAL - LIGO-Virgo data-analysis software suite"
HOMEPAGE="https://wiki.ligo.org/Computing/LALSuite"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+lalmetaio +lalframe +lalpulsar +lalsimulation +lalinspiral +lalburst +lalinference +lalapps"

RDEPEND="
	=sci-libs/lal-7.1.4-r0
	lalmetaio? ( =sci-libs/lalmetaio-2.0.3-r0 )
	lalframe? ( =sci-libs/lalframe-1.5.5-r0 )
	lalpulsar? ( =sci-libs/lalpulsar-3.1.0-r0 )
	lalsimulation? ( =sci-libs/lalsimulation-3.0.0-r0 )
	lalinspiral? ( =sci-libs/lalinspiral-2.0.3-r0 )
	lalburst? ( =sci-libs/lalburst-1.5.9-r0 )
	lalinference? ( =sci-libs/lalinference-3.0.0-r0 )
	lalapps? ( =sci-libs/lalapps-7.3.0-r0 )
"
