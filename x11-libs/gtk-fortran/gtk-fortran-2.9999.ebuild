# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit cmake-utils fortran-2 git-2

DESCRIPTION="Cross-platform library to build GUIs for Fortran programs"
HOMEPAGE="https://github.com/jerryd/gtk-fortran/wiki"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

EGIT_REPO_URI="https://github.com/jerryd/gtk-fortran.git"

DEPEND=">=x11-libs/gtk+-2.24 x11-libs/cairo x11-libs/gdk-pixbuf"
RDEPEND="${DEPEND}"

# Cannot do a parallel build:
src_compile() {
	cd "${CMAKE_BUILD_DIR}"
	emake -j1 VERBOSE=1 || die
}
