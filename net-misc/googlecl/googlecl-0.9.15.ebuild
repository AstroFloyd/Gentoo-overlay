# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=3
PYTHON_DEPEND="2:2.7"

inherit distutils

DESCRIPTION="Command line tools for the Google Data APIs"
HOMEPAGE="https://github.com/vinitkumar/googlecl"
SRC_URI="https://github.com/vinitkumar/${PN}/archive/v${PV}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86 ~arm-linux ~x86-linux"
IUSE=""

DEPEND=""
RDEPEND="
	dev-python/gdata
"

pkg_setup() {
	python_set_active_version 2
}

src_install() {
	distutils_src_install

	dodoc changelog    || die "dodoc failed"
	doman docs/man/*.1 || die "doman failed"
}
