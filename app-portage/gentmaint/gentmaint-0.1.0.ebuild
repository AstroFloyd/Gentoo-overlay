# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

DESCRIPTION="A collection of scripts to aid Gentoo maintenance"
HOMEPAGE="http://gentmaint.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND=""
RDEPEND="${DEPEND}"

src_install() {
	dodoc README CHANGELOG VERSION
	dosbin gentmaint-*
	keepdir /var/log/gentmaint/auto /var/log/gentmaint/manual
}
