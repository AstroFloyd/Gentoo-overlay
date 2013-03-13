# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

DESCRIPTION="Core routines for gravitational-wave data analysis with LIGO and Virgo"
HOMEPAGE="https://www.lsc-group.phys.uwm.edu/daswg/projects/lalsuite.html"
SRC_URI="https://www.lsc-group.phys.uwm.edu/daswg/download/software/source/lalsuite/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc libframe metaio +shared-libs static-libs xml"

DEPEND="sci-libs/gsl
		sci-libs/fftw
		doc? ( app-text/texlive-core
			   dev-texlive/texlive-genericrecommended
			   dev-texlive/texlive-fontsrecommended
			   dev-texlive/texlive-latexrecommended
			   dev-texlive/texlive-latexextra )
		libframe? ( sci-libs/libframe )
		metaio? ( >=sci-libs/metaio-8.0 )
"
RDEPEND=${DEPEND}

use libframe        || CONFIG_OPTS="${CONFIG_OPTS} --enable-frame=no"     # Remove support for libFrame if not selected
use libframe        && CONFIG_OPTS="${CONFIG_OPTS} --enable-frame=yes"    # Build support for libFrame if selected (default)
use metaio          || CONFIG_OPTS="${CONFIG_OPTS} --enable-metaio=no"    # Remove support for libMetaIo if not selected
use metaio          && CONFIG_OPTS="${CONFIG_OPTS} --enable-metaio=yes"   # Build support for libMetaIo if selected (default)
use shared-libs     || CONFIG_OPTS="${CONFIG_OPTS} --enable-shared=no"    # Don't build shared (dynamic) libraries (default is: do build)
use static-libs     || CONFIG_OPTS="${CONFIG_OPTS} --enable-static=no"    # Don't build static libraries (default is: do build)
use xml             && CONFIG_OPTS="${CONFIG_OPTS} --enable-xml=yes"      # Build support for XML files
use xml             || CONFIG_OPTS="${CONFIG_OPTS} --enable-xml=no"       # Don't build support for XML files (default)

src_compile() {
	emake
	use doc  &&  emake dvi
}

pkg_postinst() {
	elog "\n\n    Now you may want to setup your environment:"
	elog "\n    Bourne shell [bash] users: please add the"
	elog "    following lines to your .profile file:"
	elog "\n        . /etc/lal-user-env.sh"
	elog "\n    C-shell [tcsh] users: please add the following"
	elog "    lines to your .login file:"
	elog "\n        source /etc/lal-user-env.csh\n\n"

	use doc && elog "    The LAL documentation can be found in /usr/share/doc/${P}\n\n"
}
