# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Simulation of Multiprocessor Real-Time Scheduling with Overheads - gui"
HOMEPAGE="http://projects.laas.fr/simso/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="CeCILL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="~sci-misc/simso-0.8.5"
