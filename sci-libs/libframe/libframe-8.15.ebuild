# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="Handle the Frame data format for the gravitational-wave detectors Virgo and LIGO."
HOMEPAGE="http://wwwlapp.in2p3.fr/virgo/FrameL/"
SRC_URI="http://wwwlapp.in2p3.fr/virgo/FrameL/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND=${DEPEND}

DESTDIR=/usr

src_unpack() {
	unpack ${A}
	cd "${S}"
}

src_compile() {
	pwd
	cd "${S}/mgr"
	./makegcc || die "mgr/makegcc failed"
}

src_install() {
	# Install 'manually':

	MYUNAME=`uname`-`uname -m`  # e.g: "Linux-i686"
	cd "${S}/${MYUNAME}"

	mkdir -p "${D}${DESTDIR}/bin"
	cp FrCheck FrCopy FrDump "${D}${DESTDIR}/bin/"

	mkdir -p "${D}${DESTDIR}/lib"
	cp *.a *.so "${D}${DESTDIR}/lib/"

	cd ../src
	mkdir -p "${D}${DESTDIR}/include"
	cp *.h "${D}${DESTDIR}/include/"
}

pkg_config()
{
	eerror "This ebuild does not have a config function."
}
