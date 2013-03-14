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
IUSE="doc +frame +metaio +shared-libs static-libs -xml"

DEPEND="sci-libs/gsl
		sci-libs/fftw
		doc? ( app-text/texlive-core
			   dev-texlive/texlive-genericrecommended
			   dev-texlive/texlive-fontsrecommended
			   dev-texlive/texlive-latexrecommended
			   dev-texlive/texlive-latexextra )
		frame? ( sci-libs/libframe )
		metaio? ( >=sci-libs/metaio-8.0 )
"
RDEPEND=${DEPEND}

src_configure() {
	econf \
		$(use_enable frame) \
		$(use_enable metaio) \
		$(use_enable xml) \
		$(use_enable shared-libs shared) \
		$(use_enable static-libs static)
}

src_compile() {
	emake
	use doc  &&  emake dvi
}

pkg_postinst() {
	elog "\n    Now you may want to setup your environment:"
	elog "\n    Bourne shell [bash] users: please add the following line to your .profile file:"
	elog "\n        . /etc/lal-user-env.sh"
	elog "\n    C-shell [tcsh] users: please add the following line to your .login file:"
	elog "\n        source /etc/lal-user-env.csh"
	elog ""

	use doc && elog "    The LAL documentation can be found in /usr/share/doc/${P}\n"
}
