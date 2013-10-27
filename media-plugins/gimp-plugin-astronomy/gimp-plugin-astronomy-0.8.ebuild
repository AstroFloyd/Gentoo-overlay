# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

DESCRIPTION="Gimp plugins for astronomical image processing"
HOMEPAGE="http://registry.gimp.org/node/2352"
SRC_URI="http://www.hennigbuam.de/georg/downloads/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="fftw"

DEPEND="fftw? ( sci-libs/fftw )"
RDEPEND="${DEPEND}"
