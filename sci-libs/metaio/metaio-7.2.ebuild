# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $


DESCRIPTION="The metiao library can read XML files compressed with the gzip compression algorithm."
HOMEPAGE="https://www.lsc-group.phys.uwm.edu/daswg/projects/metaio.html"
SRC_URI="https://www.lsc-group.phys.uwm.edu/daswg/projects/metaio/release-7-2/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND=${DEPEND}

#Use --prefix=/usr below to install this package in /usr
DESTDIR=/



src_unpack() {
    unpack ${A}
    cd "${S}"
}


src_compile() {
    econf --prefix=/usr
    emake || die "emake failed"
}

src_install() {
    emake DESTDIR="${D}${DESTDIR}" install || die "install failed"
    dodoc README || die
}

pkg_config()
{
    eerror "This ebuild does not have a config function."
}

