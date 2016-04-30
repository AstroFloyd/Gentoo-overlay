# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

DESCRIPTION="Man pages for the Linux Kernel API"
HOMEPAGE="https://www.kernel.org/doc"
SRC_URI="https://cdn.kernel.org/pub/linux/kernel/v4.x/linux-${PV}.tar.xz"

KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
SLOT="0"
LICENSE="GPL-2"

S="${WORKDIR}/linux-${PV}"

# On 64-bit machines, make may want to execute arch/amd64/Makefile, which doesn't exist
src_prepare() {
	cd arch/
	ln -s x86 amd64
	cd -
}

src_compile() {
	emake mandocs || die "Make mandocs failed"
}

src_install() {
	doman `find Documentation/DocBook/man/ -name "*.9.gz"`
}
