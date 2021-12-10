# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Burst package of the LIGO/Virgo libraries"
HOMEPAGE="https://wiki.ligo.org/Computing/LALSuite"
SRC_URI="https://software.igwn.org/sources/source/lalsuite/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="-fast-gsl +fast-install static-libs"

DEPEND="sci-libs/gsl
		sci-libs/lalmetaio
		sci-libs/lalsimulation
		sci-libs/lal
		sci-libs/metaio
	"
RDEPEND=${DEPEND}

src_configure() {
	econf \
		$(use_enable fast-gsl) \
		$(use_enable fast-install) \
		$(use_enable static-libs static)
		# Not sure:
		#		$(use_disable libtool-lock) \     avoid locking (might break parallel builds)
}

pkg_postinst() {
	elog "\n    Now you may want to setup your environment:"
	elog "\n    Bourne shell [bash] users: please add the following line to your .profile file:"
	elog "\n        . /etc/lalburst-user-env.sh"
	elog "\n    C-shell [tcsh] users: please add the following line to your .login file:"
	elog "\n        source /etc/lalburst-user-env.csh"
	elog ""
}
