# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
MY_P=${PN}-1.25-0  # Note the last dash

inherit rpm

DESCRIPTION="Open Science Grid CA-Certificate distribution"
HOMEPAGE="http://software.grid.iu.edu"
SRC_URI="http://software.grid.iu.edu/yum/rpms/noarch/${MY_P}.noarch.rpm"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=" "

DEPEND=""
RDEPEND="${DEPEND}"

S=${WORKDIR}  # The usual definition of ${S} := ${WORKDIR}/${P} does not exist;
			  # src_prepare etc. will stuble over this

src_install() {
	dodir "/etc/grid-security/certificates/"
	insinto "/etc/grid-security/certificates/"
	doins "${WORKDIR}/etc/grid-security/certificates/*"
}
