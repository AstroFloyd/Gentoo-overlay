# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="LAL - LIGO-Virgo data-analysis software suite"
HOMEPAGE="https://wiki.ligo.org/Computing/LALSuite"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="all-lal cfitsio doc fast-gsl fast-install framel mpi openmp python swig swig-iface swig-python -static-libs -static-binaries -swig-octave
		  +lalmetaio +lalframe +lalpulsar +lalsimulation +lalinspiral +lalburst +lalinference +lalapps"

RDEPEND="
	=sci-libs/lal-7.1.4-r0[doc?,fast-gsl?,fast-install?,python?,static-libs?,swig?,swig-iface?,swig-octave?,swig-python?]
	lalmetaio? ( =sci-libs/lalmetaio-2.0.3-r0[doc?,fast-install?,python?,static-libs?,swig?,swig-iface?,swig-python?,swig-octave?] )
	lalframe? ( =sci-libs/lalframe-1.5.5-r0[doc?,fast-install?,framel?,python?,static-libs?,swig?,swig-iface?,swig-octave?,swig-python?] )
	lalpulsar? ( =sci-libs/lalpulsar-3.1.0-r0[all-lal?,cfitsio?,doc?,fast-gsl?,fast-install?,lalframe?,openmp?,python?,static-libs?,swig?,swig-iface?,swig-octave?,swig-python?] )
	lalsimulation? ( =sci-libs/lalsimulation-3.0.0-r0[doc?,fast-gsl?,fast-install?,openmp?,python?,static-libs?,swig?,swig-iface?,swig-octave?,swig-python?] )
	lalinspiral? ( =sci-libs/lalinspiral-2.0.3-r0[all-lal?,doc?,fast-gsl?,fast-install?,lalburst?,python?,static-libs?,swig?,swig-iface?,swig-octave?,swig-python?] )
	lalburst? ( =sci-libs/lalburst-1.5.9-r0[fast-gsl?,fast-install?,static-libs?] )
	lalinference? ( =sci-libs/lalinference-3.0.0-r0[all-lal?,doc?,lalburst?,lalframe?,lalinspiral?,lalmetaio?,lalpulsar?,openmp?,python?,swig?,swig-iface?,swig-python?,fast-gsl?,fast-install?,mpi?,static-libs?,swig-octave?] )
	lalapps? ( =sci-libs/lalapps-7.3.0-r0[all-lal?,cfitsio?,doc?,fast-gsl?,fast-install?,framel?,lalburst?,lalframe?,lalinference?,lalinspiral?,lalmetaio?,lalpulsar?,lalsimulation?,python?,static-binaries?,static-libs?] )
"
