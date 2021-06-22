# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

# include functions from eutils
#inherit eutils

DESCRIPTION="Bayesian inference data-analysis package for LIGO and Virgo"
HOMEPAGE="https://wiki.ligo.org/Computing/LALSuite"
SRC_URI="https://software.igwn.org/sources/source/lalsuite/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="-xml"

DEPEND="
		sci-libs/libframe
		sci-libs/lalframe
		sci-libs/metaio
		sci-libs/lalmetaio
		sci-libs/lal
		sci-libs/lalinspiral
		sci-libs/lalpulsar
		sci-libs/lalsimulation
		sci-libs/fftw
		sci-libs/gsl
		sys-libs/zlib
		xml? ( sci-libs/lalxml )
	"
RDEPEND=${DEPEND}

src_configure() {
	econf $(use_enable xml lalxml)
}

pkg_postinst() {
	elog "\n    Now you may want to setup your environment:"
	elog "\n    Bourne shell [bash] users: please add the following line to your .profile file:"
	elog "\n        . /etc/lalinference-user-env.sh"
	elog "\n    C-shell [tcsh] users: please add the following line to your .login file:"
	elog "\n        source /etc/lalinference-user-env.csh"
	elog ""
}
