# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $


#inherit qt3

DESCRIPTION="Program allowing handling of group files from a TI calculator."
HOMEPAGE="http://lpg.ticalc.org/prj_tilp"
#SRC_URI="ftp://ohnopublishing.homelinux.net/distfiles/${P}.tar.gz"
#SRC_URI="http://www.ticalc.org/pub/unix/gfm.tar.gz"
SRC_URI="http://www.astro.ru.nl/~sluys/Public/distfiles/gfm-1.04.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="kde xinerama"

RDEPEND=">=sci-calculators/tilp2-1.10
	>=x11-libs/gtk+-2.6.0
	>=dev-libs/glib-2.6.0
	>=gnome-base/libglade-2
	kde? ( >=kde-base/kdelibs-3.5 )
	xinerama? ( x11-libs/libXinerama )"

DEPEND="${RDEPEND}
	xinerama? ( x11-proto/xineramaproto )"

src_compile() {
	econf \
	$(use_with kde) \
	$(use_with xinerama) \
	|| die "econf failed"
	
	emake || die "emake failed"
}

src_install() {
	emake install DESTDIR="${D}" || die "emake install failed"
}
