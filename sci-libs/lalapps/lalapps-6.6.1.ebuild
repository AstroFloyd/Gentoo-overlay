# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Applications for gravitational-wave data analysis with LIGO/Virgo"
HOMEPAGE="https://wiki.ligo.org/Computing/LALSuite"
SRC_URI="https://software.igwn.org/sources/source/lalsuite/${P}.tar.gz
http://www.astro.ru.nl/~sluys/Stuff/${PN}_missing-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc +mpi +metaio +frame -xml"

DEPEND="=sci-libs/lal-6.6.1-r0
		sci-libs/libframe
		sci-libs/metaio
		=sci-libs/lalframe-1.0.4-r0
		=sci-libs/lalmetaio-1.0.3-r0
		=sci-libs/lalxml-1.1.2-r0
		mpi? ( virtual/mpi )
	   "
RDEPEND=${DEPEND}

src_configure() {
	econf \
		$(use_enable frame) \
		$(use_enable frame lalframe) \
		$(use_enable metaio) \
		$(use_enable metaio lalmetaio) \
		$(use_enable xml lalxml) \
		$(use_enable mpi)
}

src_compile() {
	emake || die "emake failed"
	use doc && (
		emake dvi || die "emake dvi failed" )
}

pkg_postinst() {
	elog "\n\n    Now you may want to setup your environment:"
	elog "\n    Bourne shell [bash] users: please add the"
	elog "    following lines to your .profile file:"
	elog "\n        . /etc/lalapps-user-env.sh"
	elog "\n    C-shell [tcsh] users: please add the following"
	elog "    lines to your .login file:"
	elog "\n        source /etc/lalapps-user-env.csh\n\n"
}
