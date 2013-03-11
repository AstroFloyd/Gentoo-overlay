# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

# include functions from eutils
#inherit eutils

DESCRIPTION="Handle the Frame data format for the gravitational-wave detectors Virgo and LIGO."
HOMEPAGE="https://www.lsc-group.phys.uwm.edu/daswg/projects/lalsuite.html"
SRC_URI="https://www.lsc-group.phys.uwm.edu/daswg/download/software/source/lalsuite/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="sci-libs/lalmetaio
	"
RDEPEND=${DEPEND}

DESTDIR=/

src_unpack() {
	einfo "\n\n\n  Unpacking source:\n"
	unpack ${A}
	cd "${S}"
}

src_prepare() {
	einfo "\n\n\n  Preparing source:\n"
	# Fix call to __builtin___snprintf_chk will always overflow destination buffer errors:
	#epatch "${FILESDIR}/${P}-NRWaveInject.patch"
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
