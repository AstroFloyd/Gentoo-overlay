# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

DESCRIPTION="A flexible command-line scientific calculator"
HOMEPAGE="http://w-calc.sourceforge.net/"
SRC_URI="mirror://sourceforge/w-calc/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="readline"

DEPEND="
	dev-libs/gmp:*
	dev-libs/mpfr:*
	readline? ( sys-libs/readline:* )"
RDEPEND="${DEPEND}"

src_configure() {
	econf $(use_with readline)
}
