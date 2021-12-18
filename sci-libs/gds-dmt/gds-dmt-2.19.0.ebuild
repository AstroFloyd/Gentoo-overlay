# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="LIGO Global Diagnostic System"
HOMEPAGE="http://software.ligo.org/lscsoft"
SRC_URI="http://software.ligo.org/lscsoft/source/${P}.tar.gz"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="fast-install -largefile -libtool-lock monitors omega online root-objects static-libs"
# offline

RDEPEND="dev-libs/expat
		 dev-libs/openssl
		 sci-libs/fftw
		 sci-libs/gds-frameio
		 sci-libs/gds-lsmp
		 sci-libs/gds
		 sci-libs/ldas-tools-al
		 sci-libs/ldas-tools-framecpp
		 sci-libs/metaio
		 sci-physics/root:*
		 sys-libs/zlib
"
DEPEND=${RDEPEND}

src_configure() {
	econf \
		$(use_enable fast-install) \
		$(use_enable largefile) \
		$(use_enable libtool-lock) \
		$(use_enable monitors) \
		$(use_enable omega) \
		$(use_enable online) \
		$(use_enable root-objects) \
		$(use_enable static-libs static) \
		--includedir=/usr/include/gds
	# Header files are expected to sit in /usr/include/gds
}
#		$(use_enable offline) \
