# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
CMAKE_MAKEFILE_GENERATOR=emake
inherit cmake fortran-2

DESCRIPTION="Analyse output from the gravitational-wave data-analysis code SPINspiral"
HOMEPAGE="http://${PN}.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="|| ( sci-libs/pgplot  sci-libs/plplot )
	>=sci-libs/libsufr-0.5.4
	"

RDEPEND="${DEPEND}
	media-gfx/imagemagick
	app-text/a2ps
	"

DOCS="CHANGELOG README VERSION analysemcmc.dat compPDFs.dat"

MAKEOPTS="-j1"  # Module cannot be built and used at the same time
