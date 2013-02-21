# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit fortran-2 subversion cmake-utils

DESCRIPTION="TWIN is a binary stellar evolution code"
HOMEPAGE="https://svn.science.ru.nl/wsvn/stars/trunk/"
ESVN_REPO_URI="https://svn.science.ru.nl/repos/stars/trunk"

LICENSE="other"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}
		>=dev-util/cmake-2.4
	   "
