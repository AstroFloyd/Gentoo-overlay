# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="LIGO Global Diagnostic System"
HOMEPAGE="http://software.ligo.org/lscsoft"
SRC_URI="http://software.ligo.org/lscsoft/source/${P}.tar.gz"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="dtt fast-install -largefile -libtool-lock monitors omega online only-dtt static-libs"
# dmtviewer nogui offline rts

RDEPEND="dev-libs/expat
		 dev-libs/openssl
		 sci-libs/fftw
		 sci-libs/gds-lsmp
		 sci-libs/gds
		 sci-libs/ldas-tools-al
		 sci-libs/ldas-tools-framecpp
		 sys-libs/zlib"
DEPEND=${RDEPEND}

src_configure() {
	econf \
		$(use_enable dtt) \
		$(use_enable fast-install) \
		$(use_enable largefile) \
		$(use_enable libtool-lock) \
		$(use_enable monitors) \
		$(use_enable omega) \
		$(use_enable online) \
		$(use_enable only-dtt) \
		$(use_enable static-libs static) \
		--disable-dmtviewer \
		--enable-nogui \
#		--disable-rts \  # configure: WARNING: unrecognized options: --with-rts, --without-rts.  Cannot mention rts here (--enable-rts or --disable-rts)
		--includedir=/usr/include/gds
	# Header files are expected to sit in /usr/include/gds
}
#		$(use_enable dmtviewer) \
#		$(use_enable offline) \
#		$(use_enable nogui) \
#		$(use_enable rts) \

src_install() {
	emake DESTDIR="${D}${DESTDIR}" install
#	dodoc README || die
}
