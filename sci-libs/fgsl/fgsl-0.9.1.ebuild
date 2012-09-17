# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="A Fortran interface to the GNU Scientific Library"
HOMEPAGE="http://www.lrz-muenchen.de/services/software/mathematik/gsl/fortran/"
SRC_URI="http://www.lrz-muenchen.de/services/software/mathematik/gsl/fortran/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
#IUSE="gfortran ifort"  #Compiler gfortran does not (properly) support ISO_C_BINDING
IUSE="ifort"

DEPEND=">=sci-libs/gsl-1.10
	ifort? ( >=dev-lang/ifc-10.0.026-r1 )"
RDEPEND=${DEPEND}

DESTDIR="/usr"

BITS="32"
if use amd64; then
	BITS="64"
fi



src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${P}-configure.patch  #Allows the use of econf
	epatch "${FILESDIR}"/${P}-Makefile.patch   #Makes make more verbose
}


src_compile() {
	if use ifort; then
		econf --prefix ${DESTDIR} --gsl ${DESTDIR} --f90 ifort --bits ${BITS}
	#elif use gfortran; then
	#	econf --prefix ${DESTDIR} --gsl ${DESTDIR} --f90 gfortran --bits ${BITS}
	else
		die "  You must select at least one Fortran compiler in your use flags"
	fi

	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}${DESTDIR}" install || die "install failed"
	dodoc README || die
}

pkg_config()
{
	eerror "This ebuild does not have a config function."
}

