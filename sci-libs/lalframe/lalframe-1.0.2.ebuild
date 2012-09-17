# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

DESCRIPTION="LALFrame provides a LAL wrapper for libframe."
HOMEPAGE="https://www.lsc-group.phys.uwm.edu/daswg/projects/lalsuite.html"
SRC_URI="https://www.lsc-group.phys.uwm.edu/daswg/download/software/source/lalsuite/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="sci-libs/lal
	sci-libs/libframe
	"
RDEPEND=${DEPEND}

DESTDIR=/




src_unpack() {
    unpack ${A}
    cd "${S}"
}

src_configure() {
    einfo "\n\n\n  Configuring code:\n"
    econf ${CONFIG_OPTS}
}

src_compile() {
    einfo "\n\n\n  Compiling code:\n"
    emake || die "emake failed"
}

src_install() {
    einfo "\n\n\n  Installing package:\n"
    emake DESTDIR="${D}${DESTDIR}" install || die "install failed"
}

pkg_config()
{
    eerror "This ebuild does not have a config function."
}

