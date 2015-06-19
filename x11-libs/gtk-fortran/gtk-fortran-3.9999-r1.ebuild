# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit cmake-utils fortran-2 git-2

DESCRIPTION="Cross-platform Fortran binding to create GUIs using GTK+"
HOMEPAGE="https://github.com/jerryd/gtk-fortran/wiki"

LICENSE="GPL-3"
SLOT="3"
KEYWORDS="~amd64 ~x86"

EGIT_REPO_URI="https://github.com/jerryd/gtk-fortran.git"
EGIT_BRANCH="gtk3"

DEPEND="x11-libs/gtk+:3 x11-libs/cairo x11-libs/gdk-pixbuf"
RDEPEND="${DEPEND}"

# Cannot do a parallel build:
src_compile() {
	cd "${CMAKE_BUILD_DIR}"
	emake -j1 VERBOSE=1 || die
}
