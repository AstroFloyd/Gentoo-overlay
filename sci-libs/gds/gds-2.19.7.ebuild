# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Global Diagnostic System"
HOMEPAGE="http://software.ligo.org/lscsoft"
SRC_URI="http://software.ligo.org/lscsoft/source/${P}.tar.gz"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=""
DEPEND=${RDEPEND}

src_prepare() {
	eapply -p0 "${FILESDIR}/${P}-compound.cc.patch"
	eapply_user
}

# src_configure() {
# 	econf \
# 		$(use_enable fast-install) \
# 		$(use_enable static-libs static)
# }
# #		$(use_enable ligotools) \  # Requires additional dependencies?

src_install() {
	emake DESTDIR="${D}${DESTDIR}" install
	dodoc README || die
}
