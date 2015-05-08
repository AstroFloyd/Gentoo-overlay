# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

DESCRIPTION="Tool to generate a Debian-style source package from a regular source code archive"
HOMEPAGE="https://launchpad.net/dh-make"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=" ~amd64 ~x86"

S="${WORKDIR}/${PN}"
SRC_URI="https://launchpad.net/${PN}/main/${PV}/+download/${PN}_${PV}.tar.gz"

DEPEND="dev-util/debhelper"
RDEPEND="${DEPEND}"

# Install the contents of lib/ in /usr/share/debhelper/dh_make/
# I think debian/ contains metadata about this package, and I use selected files for documentation
src_install() {
	dobin dh_make
	doman dh_make.1
	for dir in lib/*  # no dirinto for dodir...; doins can't do directories?
	do
		subdir=`echo ${dir} | sed -e 's/lib\///g'`
		insinto usr/share/debhelper/dh_make/${subdir}
		doins ${dir}/*
	done
	newdoc debian/README.Debian README
	dodoc debian/changelog
}
