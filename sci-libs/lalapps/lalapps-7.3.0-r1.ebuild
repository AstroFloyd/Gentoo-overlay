# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Applications for gravitational-wave data analysis with LIGO/Virgo"
HOMEPAGE="https://wiki.ligo.org/Computing/LALSuite"
SRC_URI="https://software.igwn.org/sources/source/lalsuite/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="all-lal cfitsio doc -fast-gsl +fast-install fftw
	  framel gds lalframe lalmetaio lalsimulation lalburst lalinspiral lalpulsar lalinference
	  python static-binaries static-libs"

RDEPEND="sci-libs/gsl
		 sci-libs/lal
		 cfitsio? ( sci-libs/cfitsio )
		 fftw? ( sci-libs/fftw )
		 framel? ( sci-libs/ldas-tools-framecpp )
		 lalframe? ( sci-libs/lalframe )
		 lalmetaio? ( sci-libs/lalmetaio )
		 lalsimulation? ( sci-libs/lalsimulation )
		 lalburst? ( sci-libs/lalburst )
		 lalinspiral? ( sci-libs/lalinspiral )
		 lalpulsar? ( sci-libs/lalpulsar )
		 lalinference? ( sci-libs/lalinference )
		 python? ( dev-lang/python:* )
		"
DEPEND="${RDEPEND}
		doc? ( app-text/doxygen )
		"

src_configure() {
	econf \
		$(use_enable all-lal) \
		$(use_enable cfitsio) \
		$(use_enable doc doxygen) \
		$(use_enable fast-gsl) \
		$(use_enable fast-install) \
		$(use_enable fftw) \
		$(use_enable framel) \
		$(use_enable gds) \
		$(use_enable lalburst) \
		$(use_enable lalframe) \
		$(use_enable lalinference) \
		$(use_enable lalinspiral) \
		$(use_enable lalmetaio) \
		$(use_enable lalpulsar) \
		$(use_enable lalsimulation) \
		$(use_enable python) \
		$(use_enable static-binaries) \
		$(use_enable static-libs static) \
		--enable-help2man \
		--disable-pss \
	# $(use_enable -pss) \  ???
	# Not sure:
	#		$(use_disable libtool-lock) \     avoid locking (might break parallel builds)
	# --enable-gcc-flags      turn on strict GCC warning flags [default=yes]
	#       $(use_enable macros) \            Build FAILS with -macros
	#   --enable-condor         compile for use with condor [default=no]
}

src_compile() {
	emake
	use doc  &&  emake dvi
}

pkg_postinst() {
	elog "\n    Now you may want to setup your environment:"
	elog "\n    Bourne shell [bash] users: please add the following line to your .profile file:"
	elog "\n        . /etc/lalapps-user-env.sh"
	elog "\n    C-shell [tcsh] users: please add the following line to your .login file:"
	elog "\n        source /etc/lalapps-user-env.csh"
	elog ""
}
