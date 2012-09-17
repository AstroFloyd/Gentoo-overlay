# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
CMAKE_VERBOSE=1

inherit cmake-utils

DESCRIPTION="Parameter-estimation code for gravitational-wave signals detected by LIGO/Virgo"
HOMEPAGE="http://${PN}.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="sci-libs/fftw
	sci-libs/gsl
	sci-libs/metaio
	sci-libs/libframe
	sci-libs/lal
	sci-libs/lalframe
	sci-libs/lalinspiral
	sci-libs/lalmetaio
	"
RDEPEND=${DEPEND}

src_install() {
    einfo "\n\n\n  Installing package:\n"
    cmake-utils_src_install || die "install failed"
    
    # Install documentation:
    dodoc CHANGELOG INSTALL LICENCE README VERSION doc/manual/* || die "installing doc failed"
    
    # Install example input files:
    dodir /usr/share/doc/${PF}/input_LAL-09/
    docinto input_LAL-09/
    dodoc doc/input_LAL-09/*                                  || die "installing example input files failed"
    
    dodir /usr/share/doc/${PF}/input_LAL-12/
    docinto input_LAL-12/
    dodoc doc/input_LAL-12/*                                  || die "installing example input files failed"
    
    dodir /usr/share/doc/${PF}/input_LAL-15/
    docinto input_LAL-15/
    dodoc doc/input_LAL-15/*                                  || die "installing example input files failed"
    
    dodir /usr/share/doc/${PF}/input_all/
    docinto input_all/
    dodoc doc/input_all/*                                     || die "installing example input files failed"
    
    dodir /usr/share/doc/${PF}/input_analytic-15/
    docinto input_analytic-15/
    dodoc doc/input_analytic-15/*                             || die "installing example input files failed"
    
    dodir /usr/share/doc/${PF}/input_LAL-apostolatos/
    docinto input_LAL-apostolatos/
    dodoc doc/input_apostolatos/*                             || die "installing example input files failed"
}

