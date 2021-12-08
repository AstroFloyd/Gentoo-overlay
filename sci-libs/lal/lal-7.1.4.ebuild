# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Core routines for gravitational-wave data analysis with LIGO and Virgo"
HOMEPAGE="https://wiki.ligo.org/Computing/LALSuite"
SRC_URI="https://software.igwn.org/sources/source/lalsuite/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc +fast-install -fast-gsl -fftw3-memalign -intelfft +macros +pthread-lock python +shared-libs static-libs swig -swig-iface -swig-octave -swig-python"

DEPEND="sci-libs/gsl
		sci-libs/fftw
		sci-libs/libframe
		>=sci-libs/metaio-8.0
		doc? ( app-text/texlive-core
			   dev-texlive/texlive-fontsrecommended
			   dev-texlive/texlive-latexrecommended
			   dev-texlive/texlive-latexextra )
"
#			   dev-texlive/texlive-genericrecommended
RDEPEND=${DEPEND}

src_configure() {
	econf \
		$(use_enable fast-gsl) \
		$(use_enable fast-install) \
		$(use_enable fftw3-memalign) \
		$(use_enable intelfft) \
		$(use_enable macros) \
		$(use_enable pthread-lock) \
		$(use_enable python) \
		$(use_enable shared-libs shared) \
		$(use_enable static-libs static) \
		$(use_enable swig) \
		$(use_enable swig-iface) \
		$(use_enable swig-octave) \
		$(use_enable swig-python) \
		# Not sure:
		#		$(use_disable libtool-lock) \     avoid locking (might break parallel builds)
		#		$(use_enable doxygen) \           generate Doxygen documentation
		#		$(use_enable help2man) \          automatically generate man pages with help2man [default=yes]
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
