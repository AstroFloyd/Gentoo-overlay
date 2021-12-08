# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="A LAL wrapper for the metaio package"
HOMEPAGE="https://wiki.ligo.org/Computing/LALSuite"
SRC_URI="https://software.igwn.org/sources/source/lalsuite/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc +fast-install python +shared-libs static-libs +swig +swig-iface -swig-octave -swig-python"

DEPEND="sci-libs/lal
	  >=sci-libs/metaio-8.0
		sci-libs/fftw
		sci-libs/gsl
		sys-libs/zlib
		swig? ( dev-lang/swig )
		swig-iface? ( dev-lang/swig )
		swig-octave? ( dev-lang/swig
					   sci-mathematics/octave )
		swig-python? ( dev-lang/swig
					   dev-lang/python:* )
	"
RDEPEND=${DEPEND}

src_configure() {
	econf \
		$(use_enable fast-install) \
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

pkg_postinst() {
		elog "\n    Now you may want to setup your environment:"
		elog "\n    Bourne shell [bash] users: please add the following line to your .profile file:"
		elog "\n        . /etc/lalmetaio-user-env.sh"
		elog "\n    C-shell [tcsh] users: please add the following line to your .login file:"
		elog "\n        source /etc/lalmetaio-user-env.csh"
		elog ""
}
