# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils cmake-utils fortran-2 git-r3

DESCRIPTION="Cross-platform Fortran binding to create GUIs for Fortran programs using GTK+"
HOMEPAGE="https://github.com/jerryd/gtk-fortran/wiki"

LICENSE="GPL-3"
SLOT="3"
KEYWORDS="~amd64 ~x86"

EGIT_REPO_URI="https://github.com/jerryd/gtk-fortran.git"
EGIT_BRANCH="gtk3"

IUSE="doc plplot static"
DEPEND="doc? ( app-doc/doxygen )
		plplot? ( sci-libs/plplot )
		x11-libs/gtk+:3 x11-libs/cairo x11-libs/gdk-pixbuf"
RDEPEND="plplot? ( sci-libs/plplot )
		 x11-libs/gtk+:3 x11-libs/cairo x11-libs/gdk-pixbuf"

src_prepare() {
	epatch "${FILESDIR}"/Doxyfile.patch  # Quiet, no graphs
	epatch "${FILESDIR}"/Doxyfile_man.patch  # Add manpages
}

# Cannot do a parallel build.  make install will build 'all' in parallel, which fails.
# Hence, do two partial parallel builds here, for the core stuff.
# You could do a serial 'make all' to build the rest (examples, testers, etc.).
src_compile() {
	cd "${CMAKE_BUILD_DIR}"
	emake VERBOSE=1 gtk-fortran_shared || die "Building shared library failed"  # Cannot be built at the same time as the static library/gtkf-sketcher
	emake VERBOSE=1 gtk-fortran_static || die "Building static library failed"  # The static library is built when gtkf-sketcher is built, so do this explicitly for clarity
	emake VERBOSE=1 gtkf-sketcher usemodules manpage pkgconfig || die
	use plplot && $(emake VERBOSE=1 plplot_extra_module || die "Creating plplot_extra_module failed")
	use doc && $(emake VERBOSE=1 doc || die "Generating documentation failed")  # Doxygen documentation: ~135Mb!
	#emake -j1 VERBOSE=1 all || die
}

# 'make install' will 'make all' in parallel, which fails, so do this by hand:
src_install() {
	cd "${CMAKE_BUILD_DIR}"
	dolib src/libgtk-3-fortran.so.0.1 src/libgtk-3-fortran.so
	use static && dolib src/libgtk-3-fortran.a  # The static library is always built, we just don't install it unless desired...

	dobin src/gtk-3-fortran-modscan sketcher/gtkf-sketcher

	insinto usr/include/gtk-3-fortran/
	doins src/*.mod
	use plplot && doins plplot/plplot_extra.mod

	insinto usr/share/gtk-fortran/
	doins src/gtk-3-fortran-index.csv src/gtk-3-enumerators.lis

	dodoc "${S}"/README "${S}"/README-high-level

	insinto usr/lib/pkgconfig/
	doins src/gtk-3-fortran.pc

	doman src/gtk-3-fortran-modscan.1

	if use doc; then
		dohtml -r html/*

		rm -f man/man3f/height.3f man/man3f/name.3f man/man3f/p1.3f man/man3f/p2.3f  # These exist in other packages
		insinto usr/share/man/man3f/
		doins man/man3f/*  # Copying these ~16k files alone takes ~8min on my system, hence no doman here!
	fi
}
