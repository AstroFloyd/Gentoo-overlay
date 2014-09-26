# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

DESCRIPTION="Binary version of VMware open client using the PCoIP protocol"
HOMEPAGE="http://www.virtualvcp.com/linux-technical-guides/171-installing-the-vmware-view-pcoip-client-on-linux"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND=""
RDEPEND=""

src_install() {
	dodoc README CHANGELOG VERSION
	dobin usr/bin/*
	dolib usr/lib/*
	keepdir /etc/vmware/
}

pkg_postinst() {
	ewarn "This is an experimental ebuild.  This version is not supported by VMware.  Use at your own risk!"
}
