# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="A library for parsing LIGO/Virgo LIGO_LW Table files"
HOMEPAGE="https://www.lsc-group.phys.uwm.edu/daswg/projects/metaio.html"
SRC_URI="http://software.ligo.org/lscsoft/source/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

src_install() {
	emake DESTDIR="${D}${DESTDIR}" install
	dodoc README || die
}
