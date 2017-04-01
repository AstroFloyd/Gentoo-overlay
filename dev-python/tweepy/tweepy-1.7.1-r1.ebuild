# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Python library for the Twitter/Identi.ca API, including Oauth and Xauth"
HOMEPAGE="http://pypi.python.org/pypi/tweepy/"
SRC_URI="http://pypi.python.org/packages/source/t/tweepy/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=dev-lang/python-2.4:*
				dev-python/simplejson"
RDEPEND="${DEPEND}"
