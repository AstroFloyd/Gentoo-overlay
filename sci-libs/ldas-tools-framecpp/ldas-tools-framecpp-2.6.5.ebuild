# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="LIGO Data Analysis Tools Frame cpp"
HOMEPAGE="http://software.igwn.org"
SRC_URI="http://software.igwn.org/lscsoft/source/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="fast-install -static-libs"  # doc latex

DEPEND="dev-libs/boost dev-libs/openssl sci-libs/ldas-tools-al sys-libs/zlib"
RDEPEND="${DEPEND}"

src_configure() {
	econf \
		$(use_enable fast-install) \
		$(use_enable static-libs static) \
	--disable-latex \
	--disable-warnings-as-errors
}
#		$(use_enable latex) \

# src_install() {
# 	use doc || rm -rf "${WORKDIR}/${P}/doxygen/html"
# 	emake DESTDIR="${D}${DESTDIR}" install
#
# }
