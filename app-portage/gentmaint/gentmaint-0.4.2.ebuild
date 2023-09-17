# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="A collection of scripts to aid Gentoo maintenance"
HOMEPAGE="http://gentmaint.sourceforge.net/"
SRC_URI="https://github.com/AstroFloyd/gentmaint/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND=""
RDEPEND="app-portage/portage-utils
		 app-portage/gentoolkit
		 app-portage/eix
		 app-arch/bzip2
		 sys-apps/less
		 sys-process/time"

src_install() {
	dodoc readme.org  # CHANGELOG VERSION
	dobin code/gentmaint-*
	doman doc/gentmaint.1
	keepdir /var/log/gentmaint /var/log/gentmaint/auto /var/log/gentmaint/manual
}
