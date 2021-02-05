# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="A collection of scripts to aid Gentoo maintenance"
HOMEPAGE="http://gentmaint.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND=""
RDEPEND="app-portage/portage-utils
		 app-portage/gentoolkit
		 app-portage/layman
		 app-portage/eix
		 app-arch/bzip2
		 sys-apps/less
		 sys-process/time"

src_install() {
	dodoc README CHANGELOG VERSION
	dobin gentmaint-*
	doman gentmaint.1
	keepdir /var/log/gentmaint /var/log/gentmaint/auto /var/log/gentmaint/manual
}
