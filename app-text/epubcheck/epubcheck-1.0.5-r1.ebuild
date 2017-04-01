# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="Verify .epub eBook format"
HOMEPAGE="http://code.google.com/p/epubcheck/"
SRC_URI="http://epubcheck.googlecode.com/files/epubcheck-src-${PV}.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND=">=virtual/jdk-1.5
		>=dev-java/ant-1.6"
RDEPEND=">=virtual/jre-1.5"

DESTDIR="/"

src_unpack() {
	unpack ${A}
}

src_compile() {
	BITS="32"
	if use amd64; then
		BITS="64"
	fi

	ant -f build.xml || die "emake failed"
}

src_test() {
	emake check || die "emake check failed"
}

src_install() {
	mkdir -pv "${D}opt/${P}"
	cp -pr bin dist "${D}opt/${P}" || die "install failed"
	dodoc README.txt COPYING.txt jing_license.txt || die
}

pkg_postinst() {
	elog "epubcheck is installed in /opt/${P}/"
	elog "Run:  java -jar /opt/${P}/dist/${P}.jar book.epub  to check the format of book.epub"
}

pkg_config() {
	eerror "This ebuild does not have a config function."
}
