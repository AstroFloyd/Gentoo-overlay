# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Bayesian inference data-analysis package for LIGO and Virgo"
HOMEPAGE="https://wiki.ligo.org/Computing/LALSuite"
SRC_URI="https://software.igwn.org/sources/source/lalsuite/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="all-lal doc -fast-gsl fast-install lalburst lalframe lalinspiral lalmetaio lalpulsar -mpi
			  -openmp python static-libs swig swig-iface swig-octave swig-python"

RDEPEND="sci-libs/gsl
		 sci-libs/lal
		 sci-libs/lalsimulation
		 lalburst? ( sci-libs/lalburst )
		 lalframe? ( sci-libs/lalframe )
		 lalinspiral? ( sci-libs/lalinspiral )
		 lalmetaio? ( sci-libs/lalmetaio )
		 lalpulsar? ( sci-libs/lalpulsar )
		 mpi? ( virtual/mpi )
		 openmp? ( sys-cluster/openmpi )
		 python? ( dev-lang/python:* )
		 swig-octave? ( sci-mathematics/octave )
		 swig-python? ( dev-lang/python:* )
		 "
DEPEND="${RDEPEND}
		doc? ( app-doc/doxygen )
		swig? ( dev-lang/swig )
		swig-iface? ( dev-lang/swig )
		swig-octave? ( dev-lang/swig )
		swig-python? ( dev-lang/swig )
		"

src_configure() {
	econf \
		$(use_enable all-lal) \
		$(use_enable doc doxygen) \
		$(use_enable fast-gsl) \
		$(use_enable fast-install) \
		$(use_enable lalburst) \
		$(use_enable lalframe) \
		$(use_enable lalinspiral) \
		$(use_enable lalmetaio) \
		$(use_enable lalpulsar) \
		$(use_enable mpi) \
		$(use_enable openmp) \
		$(use_enable python) \
		$(use_enable static-libs static) \
		$(use_enable swig) \
		$(use_enable swig-iface) \
		$(use_enable swig-octave) \
		$(use_enable swig-python) \
		--enable-help2man
	# Not sure:
	# $(use_disable libtool-lock) \     avoid locking (might break parallel builds)
	# --enable-gcc-flags      turn on strict GCC warning flags [default=yes]
}

pkg_postinst() {
	elog "\n    Now you may want to setup your environment:"
	elog "\n    Bourne shell [bash] users: please add the following line to your .profile file:"
	elog "\n        . /etc/lalinference-user-env.sh"
	elog "\n    C-shell [tcsh] users: please add the following line to your .login file:"
	elog "\n        source /etc/lalinference-user-env.csh"
	elog ""
}
