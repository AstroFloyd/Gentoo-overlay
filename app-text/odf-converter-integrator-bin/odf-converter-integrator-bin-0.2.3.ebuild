# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
inherit eutils

MY_P=${PN/-bin/}-${PV}

DESCRIPTION="Open MS Office 2007 files (docx, xlsx, pptx) in OpenOffice.org"
SRC_URI="http://katana.oooninja.com/f/software/${MY_P}.tar.bz2"
HOMEPAGE="http://katana.oooninja.com/w/odf-converter-integrator"
KEYWORDS="~x86"
SLOT="0"
LICENSE="BSD GPL-3"
IUSE=""

src_install() {
	exeinto /usr/bin
	doexe ${MY_P}/usr/bin/*
	insinto /usr/
	doins -r ${MY_P}/usr/share/
	doins -r ${MY_P}/usr/lib/
}

