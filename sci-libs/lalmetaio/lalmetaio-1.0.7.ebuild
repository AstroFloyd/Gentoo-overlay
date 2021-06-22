# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="A LAL wrapper for the metaio package"
HOMEPAGE="https://wiki.ligo.org/Computing/LALSuite"
SRC_URI="https://software.igwn.org/sources/source/lalsuite/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="sci-libs/lal
	  >=sci-libs/metaio-8.0
		sci-libs/fftw
		sci-libs/gsl
		sys-libs/zlib
	"
RDEPEND=${DEPEND}

pkg_postinst() {
		elog "\n    Now you may want to setup your environment:"
		elog "\n    Bourne shell [bash] users: please add the following line to your .profile file:"
		elog "\n        . /etc/lalmetaio-user-env.sh"
		elog "\n    C-shell [tcsh] users: please add the following line to your .login file:"
		elog "\n        source /etc/lalmetaio-user-env.csh"
		elog ""
}
