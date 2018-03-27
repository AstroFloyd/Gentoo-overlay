# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

DESCRIPTION="Free OneDrive client written in D"
HOMEPAGE="https://github.com/skilion/onedrive"
SRC_URI="https://github.com/skilion/onedrive/archive/v${PV}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="net-misc/curl dev-db/sqlite"
RDEPEND="${DEPEND} dev-lang/dmd"

src_prepare() {
	# Obtain the package-version number from this ebuild, rather than from git:
	printf 'v%s\n' "${PV}" > version
	sed -i -e '/^onedrive:/ s/version //' -e 's:PREFIX = /usr/local:PREFIX = /usr:' Makefile
}

src_compile() {
	PREFIX=/usr make  # -C ${P}
}
