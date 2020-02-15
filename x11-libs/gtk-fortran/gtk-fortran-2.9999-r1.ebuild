# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils cmake-utils fortran-2 git-r3

DESCRIPTION="Cross-platform Fortran binding to create GUIs for Fortran programs using GTK+"
HOMEPAGE="https://github.com/jerryd/gtk-fortran/wiki"

LICENSE="GPL-3"
SLOT="2"
KEYWORDS="~amd64 ~x86"

EGIT_REPO_URI="https://github.com/jerryd/gtk-fortran.git"

IUSE="doc plplot static"
DEPEND="doc? ( app-doc/doxygen )
		plplot? ( sci-libs/plplot )
		>=x11-libs/gtk+-2.24:2 x11-libs/cairo x11-libs/gdk-pixbuf"
RDEPEND="plplot? ( sci-libs/plplot )
		 >=x11-libs/gtk+-2.24:2 x11-libs/cairo x11-libs/gdk-pixbuf"

src_prepare() {
	epatch "${FILESDIR}"/Doxyfile.patch  # Quiet, no graphs
}

# Cannot do a parallel build.  make install will build 'all' in parallel, which fails.
# Hence, do two partial parallel builds here, for the core stuff.
# You could do a serial 'make all' to build the rest (examples, testers, etc.).
src_compile() {
	cd "${CMAKE_BUILD_DIR}"
	emake VERBOSE=1 gtk-fortran_shared || die "Building shared library failed"  # Cannot be built at the same time as the static library
	use static && $(emake VERBOSE=1 gtk-fortran_static || die "Building static library failed")
	emake VERBOSE=1 usemodules manpage pkgconfig || die
	use plplot && $(emake VERBOSE=1 plplot_extra_module || die "Creating plplot_extra_module failed")
	use doc && $(emake VERBOSE=1 doc || die "Generating documentation failed")  # Doxygen documentation: ~135Mb!
	#emake -j1 VERBOSE=1 all || die
}

# 'make install' will 'make all' in parallel, which fails, so do this by hand:
src_install() {
	cd "${CMAKE_BUILD_DIR}"
	dolib src/libgtk-2-fortran.so.0.1 src/libgtk-2-fortran.so
	use static && dolib src/libgtk-2-fortran.a  # The static library is always built, we just don't install it unless desired...

	dobin src/gtk-2-fortran-modscan

	insinto usr/include/gtk-2-fortran/
	doins src/*.mod
	use plplot && doins plplot/plplot_extra.mod

	insinto usr/share/gtk-fortran/
	doins src/gtk-2-fortran-index.csv src/gtk-2-enumerators.lis

	dodoc "${S}"/README "${S}"/README-high-level

	insinto usr/lib/pkgconfig/
	doins src/gtk-2-fortran.pc

	doman src/gtk-2-fortran-modscan.1

	use doc && dohtml -r html/*
}
