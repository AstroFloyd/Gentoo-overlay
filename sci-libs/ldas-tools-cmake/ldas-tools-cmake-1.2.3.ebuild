# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
CMAKE_MAKEFILE_GENERATOR=emake
inherit cmake

DESCRIPTION="CMake scripts for the LIGO Data Analysis Software Tools"
HOMEPAGE="http://software.igwn.org/"
SRC_URI="http://software.igwn.org/lscsoft/source/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=sci-libs/igwn-cmake-macros-1.3.2"
RDEPEND=""
