# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="5"
PYTHON_COMPAT=( python2_7 )
PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.* *-jython"

inherit distutils-r1

DESCRIPTION="Remote incremental file backup utility - not maintained since 2009!"
HOMEPAGE="http://www.nongnu.org/rdiff-backup/"
SRC_URI="https://savannah.nongnu.org/download/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="acl xattr"

DEPEND=">=net-libs/librsync-0.9.7
		!arm? ( xattr? ( dev-python/pyxattr )
				acl? ( dev-python/pylibacl ) )"
RDEPEND="${DEPEND}"

DOCS="examples.html"
PYTHON_MODNAME="rdiff_backup"
