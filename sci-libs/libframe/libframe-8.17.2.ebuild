# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="Handle the Frame data format for the gravitational-wave detectors Virgo and LIGO"
HOMEPAGE="http://wwwlapp.in2p3.fr/virgo/FrameL/"
SRC_URI="http://wwwlapp.in2p3.fr/virgo/FrameL/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

src_compile() {
	cd "${S}/mgr"
	./makegcc || die "mgr/makegcc failed"
}

src_install() {
	# Install 'manually':
	MYUNAME=`uname`-`uname -m`  # e.g: "Linux-i686"
	cd "${S}/${MYUNAME}"
	dobin FrCheck FrCopy FrDump
	dolib *.a *.so

	cd ../src
	insinto /usr/include
	doins *.h
}
