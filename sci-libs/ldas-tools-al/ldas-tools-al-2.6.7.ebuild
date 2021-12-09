# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
CMAKE_MAKEFILE_GENERATOR=emake
inherit cmake

DESCRIPTION="LIGO Data Analysis Tools al"
HOMEPAGE="http://software.igwn.org"
SRC_URI="http://software.igwn.org/lscsoft/source/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="sci-libs/ldas-tools-cmake"
RDEPEND=""

# src_configure() {
# 	econf \
# 		$(use_enable fast-install) \
# 		$(use_enable static-libs static)
# }
# #		$(use_enable ligotools) \  # Requires additional dependencies?

# src_install() {
# 	emake DESTDIR="${D}${DESTDIR}" install
# 	dodoc README || die
# }
