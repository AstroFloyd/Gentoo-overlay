# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

DESCRIPTION="AMUSE is an Astrophysical Multipurpose Software Environment"
HOMEPAGE="http://www.amusecode.org/"
SRC_URI="http://www.amusecode.org/releases/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=dev-lang/python-2.6.0
	>=dev-python/numpy-1.3.0
	>=sci-libs/hdf5-1.6.5
	>=dev-python/h5py-1.2.0
	>=dev-python/docutils-0.6
	|| ( sys-cluster/mpich2  sys-cluster/openmpi )
	>=dev-python/mpi4py-1.0.0
	>=dev-python/nose-0.11
	sci-libs/fftw
	sci-libs/gsl
	dev-util/cmake
	"

RDEPEND=${DEPEND}

DESTDIR=/




src_unpack() {
    unpack ${A}
    cd "${S}"
}

src_configure() {
    einfo "\n\n\n  Configuring code:\n"
    econf ${CONFIG_OPTS}
}

src_compile() {
    einfo "\n\n\n  Compiling code:\n"
    emake || die "emake failed"
}

src_install() {
    einfo "\n\n\n  Installing package:\n"
    emake DESTDIR="${D}${DESTDIR}" install || die "install failed"
}

pkg_config()
{
    eerror "This ebuild does not have a config function."
}

