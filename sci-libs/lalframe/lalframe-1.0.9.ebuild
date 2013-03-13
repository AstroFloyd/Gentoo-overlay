# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

DESCRIPTION="A LAL wrapper for libframe"
HOMEPAGE="https://www.lsc-group.phys.uwm.edu/daswg/projects/lalsuite.html"
SRC_URI="https://www.lsc-group.phys.uwm.edu/daswg/download/software/source/lalsuite/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=sci-libs/lal-6.9.1
		  sci-libs/libframe
	   "
RDEPEND=${DEPEND}

pkg_postinst() {
	elog "\n    Now you may want to setup your environment:"
	elog "\n    Bourne shell [bash] users: please add the following line to your .profile file:"
	elog "\n        . /etc/lalframe-user-env.sh"
	elog "\n    C-shell [tcsh] users: please add the following line to your .login file:"
	elog "\n        source /etc/lalframe-user-env.csh"
	elog ""
}
