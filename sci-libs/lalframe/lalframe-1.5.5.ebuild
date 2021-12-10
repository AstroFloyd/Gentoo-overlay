# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="A LAL wrapper for libframe"
HOMEPAGE="https://wiki.ligo.org/Computing/LALSuite"
SRC_URI="https://software.igwn.org/sources/source/lalsuite/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc +fast-install +framel python static-libs +swig +swig-iface -swig-octave -swig-python"

RDEPEND="sci-libs/lal
		 sci-libs/ldas-tools-framecpp
		 python? ( dev-lang/python:* )
		 swig-octave? ( sci-mathematics/octave )
		 swig-python? ( dev-lang/python:* )
	   "
DEPEND="
		${RDEPEND}
		doc? ( app-doc/doxygen )
		swig? ( dev-lang/swig )
		swig-iface? ( dev-lang/swig )
		swig-octave? ( dev-lang/swig )
		swig-python? ( dev-lang/swig )
"

src_configure() {
	econf \
		$(use_enable doc doxygen) \
		$(use_enable fast-install) \
		$(use_enable framel) \
		$(use_enable python) \
		$(use_enable static-libs static) \
		$(use_enable swig) \
		$(use_enable swig-iface) \
		$(use_enable swig-octave) \
		$(use_enable swig-python) \
		--enable-framec \
		--enable-help2man    # generate man pages with help2man
	# Not sure:
	#		$(use_disable libtool-lock) \     avoid locking (might break parallel builds)
}

pkg_postinst() {
	elog "\n    Now you may want to setup your environment:"
	elog "\n    Bourne shell [bash] users: please add the following line to your .profile file:"
	elog "\n        . /etc/lalframe-user-env.sh"
	elog "\n    C-shell [tcsh] users: please add the following line to your .login file:"
	elog "\n        source /etc/lalframe-user-env.csh"
	elog ""
}
