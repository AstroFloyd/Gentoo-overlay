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
# 32bit 64bit dmt-runtime dmtviewer dtt  nogui offline only-dtt rts

RDEPEND="dev-libs/cyrus-sasl
		 dev-libs/expat
		 dev-libs/jsoncpp
		 net-misc/curl
		 sci-libs/fftw
		 sci-libs/metaio
		 sys-libs/zlib"
DEPEND=${RDEPEND}

src_prepare() {
	eapply -p0 "${FILESDIR}/${P}-compound.cc.patch"
	eapply_user
}

src_configure() {
	econf \
		$(use_enable fast-install) \
		$(use_enable largefile) \
		$(use_enable libtool-lock) \
		$(use_enable monitors) \
		$(use_enable omega) \
		$(use_enable online) \
		$(use_enable static-libs static) \
		--includedir=/usr/include/${PN}
	# Header files are expected to sit in /usr/include/${PN}
}
#		$(use_enable x86 32bit) \  # Fails on 64-bit system
#		$(use_enable amd64 64bit) \  # Would then fail on 32-bit system?
#		$(use_enable dmt-runtime) \  # Requires gds-dmt?
#		$(use_enable dmtviewer) \  # Requires gds-dmt?
#		$(use_enable dtt) \  # Requires gds-dtt?
#		$(use_enable nogui) \  # Requires gds-gui?
#		$(use_enable only-dtt) \  # Requires gds-dtt?
#		$(use_enable offline) \--dis/--enable doesn't work
#		$(use_enable rts) \

src_install() {
	emake DESTDIR="${D}${DESTDIR}" install
	dodoc README || die
}
