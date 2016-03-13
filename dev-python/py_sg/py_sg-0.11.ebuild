# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

#EAPI=6
EAPI=6

#PYTHON_COMPAT=( python{2_7,3_4} )

DESCRIPTION="Python SCSI generic library"
HOMEPAGE="https://pypi.python.org/pypi/py_sg/"
SRC_URI="mirror://pypi/p/py_sg/py_sg/${P}.tar.gz"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=dev-lang/python-2.4:*"
RDEPEND="${DEPEND}"
