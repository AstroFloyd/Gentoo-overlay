# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

DESCRIPTION="LALapps contains applications for gravitational-wave data analysis written in ANSI C99."
HOMEPAGE="https://www.lsc-group.phys.uwm.edu/daswg/projects/lalsuite.html"
SRC_URI="https://www.lsc-group.phys.uwm.edu/daswg/download/software/source/lalsuite/${P}.tar.gz
http://www.astro.ru.nl/~sluys/Stuff/${PN}_missing-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
#IUSE="mpi metaio lalframe lalmetaio lalxml"   # Repoman complains about these -> make dependencies non-optional...
IUSE="doc mpi"

DEPEND="=sci-libs/lal-6.6.1
		sci-libs/libframe
		sci-libs/metaio
		=sci-libs/lalframe-1.0.4
		=sci-libs/lalmetaio-1.0.3
		=sci-libs/lalxml-1.1.2
		mpi? ( virtual/mpi )
	   "
RDEPEND=${DEPEND}

src_configure() {
	econf \
		$(use_enable mpi) \
		--enable-frame --enable-lalframe --enable-metaio --enable-lalmetaio --enable-lalxml
	# Can't use use_enable for the rest, since these aren't valid USE flags
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
