# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="LIGO Global Diagnostic System"
HOMEPAGE="http://software.ligo.org/lscsoft"
SRC_URI="http://software.ligo.org/lscsoft/source/${P}.tar.gz"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="dmtviewer dtt fast-install -largefile -libtool-lock monitors gui omega online only-dtt root-objects static-libs"
# offline rts

RDEPEND="dev-libs/expat
		 sci-libs/fftw
		 sci-libs/gds
		 sci-libs/metaio
		 sci-physics/root:*
		 sys-libs/zlib
"
DEPEND=${RDEPEND}

# Need support for C++17:
CXXFLAGS="${CXXFLAGS} -std=c++17"

src_configure() {
	econf \
		$(use_enable dmtviewer) \
		$(use_enable dtt) \
		$(use_enable fast-install) \
		$(use_enable largefile) \
		$(use_enable libtool-lock) \
		$(use_enable monitors) \
		$(use_enable !gui nogui) \
		$(use_enable omega) \
		$(use_enable online) \
		$(use_enable only-dtt) \
		$(use_enable root-objects) \
		$(use_enable static-libs static) \
		--includedir=/usr/include/gds
	# Header files are expected to sit in /usr/include/gds
	# $(use_enable offline) \
	# $(use_enable rts) \
}
