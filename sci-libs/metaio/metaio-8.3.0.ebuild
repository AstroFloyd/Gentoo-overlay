# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="A library for parsing LIGO/Virgo LIGO_LW Table files"
HOMEPAGE="https://www.lsc-group.phys.uwm.edu/daswg/projects/metaio.html"
SRC_URI="https://www.lsc-group.phys.uwm.edu/daswg/download/software/source/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

src_install() {
	emake DESTDIR="${D}${DESTDIR}" install
	dodoc README || die
}
