# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="LIGO Global Diagnostic System"
HOMEPAGE="http://software.ligo.org/lscsoft"
SRC_URI="http://software.ligo.org/lscsoft/source/${P}.tar.gz"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="fast-install -largefile -libtool-lock monitors omega online static-libs"
# offline only-dtt rts

RDEPEND="sci-libs/gds
		 sys-libs/zlib"
DEPEND=${RDEPEND}

src_configure() {
	econf \
		$(use_enable fast-install) \
		$(use_enable largefile) \
		$(use_enable libtool-lock) \
		$(use_enable monitors) \
		$(use_enable omega) \
		$(use_enable online) \
		$(use_enable static-libs static) \
		--includedir=/usr/include/gds
	# Header files are expected to sit in /usr/include/gds
}
#		$(use_enable offline) \--dis/--enable doesn't work

src_install() {
	emake DESTDIR="${D}${DESTDIR}" install
}
