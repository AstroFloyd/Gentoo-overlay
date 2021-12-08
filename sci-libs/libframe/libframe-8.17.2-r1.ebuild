# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Handle the Frame data format for the gravitational-wave detectors Virgo and LIGO"
HOMEPAGE="http://wwwlapp.in2p3.fr/virgo/FrameL/"
SRC_URI="http://wwwlapp.in2p3.fr/virgo/FrameL/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="static-libs"

src_install() {
	emake DESTDIR="${D}${DESTDIR}" install
	mv "$D/usr/share/doc/${PN}" "$D/usr/share/doc/${P}"  # Doc subdir should contain package version
	use static-libs || rm "$D/usr/lib64/libFrame.a"
}
