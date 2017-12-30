# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit cmake-utils fortran-2
DESCRIPTION="Implementation of coarrays for gfortran"
HOMEPAGE="http://www.opencoarrays.org/"
SRC_URI="https://github.com/sourceryinstitute/${PN}/releases/download/${PV}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="virtual/fortran virtual/mpi"
RDEPEND="${DEPEND}"

# Source dir has capitals:
S="${WORKDIR}/OpenCoarrays-${PV}/"
