# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Tex2im converts LaTeX formulae into high-resolution bitmap graphics."
HOMEPAGE="http://www.nought.de/tex2im.html"
SRC_URI="http://www.nought.de/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

DEPEND="app-text/texlive
	media-gfx/imagemagick"
RDEPEND=${DEPEND}

DESTDIR="/usr"

src_unpack() {
	unpack ${A}
	cd "${S}"
}

src_install() {
	einfo "  Installing Tex2im:\n"
	mkdir -pv "${D}${DESTDIR}/bin/"
	cp -v tex2im "${D}${DESTDIR}/bin/" || die "install failed"
	use doc && (
		 einfo "  Installing documentation:\n"
		 mkdir -pv "${D}${DESTDIR}/share/doc/${P}" || die "Could not create doc directory"
		 cp -prv CHANGELOG LICENSE README examples "${D}${DESTDIR}/share/doc/${P}" || die "Could not copy documentation"
	)
}

pkg_postinst() {
	elog "\n    Use  tex2im -h  for command-line options. \n"
	use doc && elog "    See ${DESTDIR}/share/doc/${P} for examples of how to use Tex2im \n"
}

pkg_config()
{
	eerror "This ebuild does not have a config function."
}
