# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

DESCRIPTION="A LAL wrapper for the metaio package"
HOMEPAGE="https://www.lsc-group.phys.uwm.edu/daswg/projects/lalsuite.html"
SRC_URI="https://www.lsc-group.phys.uwm.edu/daswg/download/software/source/lalsuite/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="sci-libs/lal
	>=sci-libs/metaio-8.0
	"
RDEPEND=${DEPEND}

pkg_postinst() {
		elog "\n    Now you may want to setup your environment:"
		elog "\n    Bourne shell [bash] users: please add the following line to your .profile file:"
		elog "\n        . /etc/lalmetaio-user-env.sh"
		elog "\n    C-shell [tcsh] users: please add the following line to your .login file:"
		elog "\n        source /etc/lalmetaio-user-env.csh"
		elog ""
}
