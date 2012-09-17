# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit distutils

DESCRIPTION="A Python Library for the Twitter (and Identi.ca) API. Includes Oauth and Xauth authentification"
#HOMEPAGE="http://github.com/joshthecoder/tweepy"
HOMEPAGE="http://pypi.python.org/pypi/tweepy/"
# The original URL would be
#SRC_URI="http://github.com/joshthecoder/tweepy/tarball/${PV}"
# but github's downloads give bad names which confuses src_unpack
# so I mirrored the archive under
#SRC_URI="http://packages.monkeycode.org/${P}.tar.gz"
#MvdS:
SRC_URI="http://pypi.python.org/packages/source/t/tweepy/${P}.tar.gz"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=dev-lang/python-2.4
                dev-python/simplejson"
RDEPEND="${DEPEND}"

