# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Gimp plugins for astronomical image processing"
HOMEPAGE="http://www.hennigbuam.de/georg/gimp.html"
SRC_URI="http://www.hennigbuam.de/georg/downloads/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="fftw"

DEPEND=">=media-gfx/gimp-2.3
sci-libs/gsl
>=x11-libs/gtk+-2.7:2
fftw? ( sci-libs/fftw:3.0 )"
RDEPEND="${DEPEND}"
