# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

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
	keepdir /var/log/gentmaint /var/log/gentmaint/auto /var/log/gentmaint/manual
}

pkg_postinst() {
	einfo "The GentMaint scripts are now in /usr/bin/.  Please check your scripts and cron jobs."
}
