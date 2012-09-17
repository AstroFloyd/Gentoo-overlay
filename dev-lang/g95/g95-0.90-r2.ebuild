# Copyright 1999-2004 Gentoo Foundation
# Copyleft 2006 Honza Macháèek
# Distributed under the terms of the GNU General Public License v2

inherit eutils flag-o-matic g95

DESCRIPTION="Fortran 95 compiler"
HOMEPAGE="http://www.g95.org/"

MY_VERSION="$PV"
MY_LIB_VERSION="$MY_VERSION"
MY_GCC_VERSION="4.1.1"
MY_GCC_MAJOR=${MY_GCC_VERSION%.*}

SRC_URI="http://ftp.g95.org/v0.9/g95_source.tgz
         mirror://gnu/gcc/gcc-${MY_GCC_MAJOR}/gcc-${MY_GCC_VERSION}.tar.bz2"
LICENSE="GPL-2"
SLOT="0"

# Seems to work at least on x86 and amd64 now
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""

src_unpack() {
	pushd "${WORKDIR}"
	unpack gcc-${MY_GCC_VERSION}.tar.bz2
	unpack g95_source.tgz
	MY_VERSION=`ls -d g95-*`
	MY_VERSION=${MY_VERSION#g95-}
	if [ "X$MY_VERSION" != "X$PV" ]; then ewarn "Version changed from ${PV} \
	  to ${MY_VERSION}"; fi
	cd g95-${MY_VERSION}
	MY_LIB_VERSION="$MY_VERSION"
	tar xzf libf95.a-${MY_LIB_VERSION}.tar.gz
	epatch ${FILESDIR}/g95-${PV}-destdir.patch
	epatch ${FILESDIR}/g95-${PV}-libdir.patch

	einfo "Multilib ABIs: ${MULTILIB_ABIS}"

}

src_compile() {
	CFLAGS_SAVE=${CFLAGS}; CXXFLAGS_SAVE=${CXXFLAGS}
	mkdir "${WORKDIR}/gcc-${MY_GCC_VERSION}/g95"
	cd "${WORKDIR}/gcc-${MY_GCC_VERSION}/g95"
#	ln -s ../configure .
#	econf --enable-languages=c || die "configure gcc failed"
#	emake || die "emake gcc failed"
	filter-flags -fortran -gcj -objc -ada -java
	GCC_LANG="c"
	MY_S="${S}"
	S="${WORKDIR}/gcc-${MY_GCC_VERSION}"
	ln -s g95 "${S}/build"
	g95_gcc_do_configure
	g95_gcc_do_make
	S="${MY_S}"
	cd "${WORKDIR}"
	MY_VERSION=`ls -d g95-*`
	MY_VERSION=${MY_VERSION#g95-}
	if [ "X$MY_VERSION" != "X$PV" ]; then ewarn "Version changed from ${PV} \
	  to ${MY_VERSION}"; fi
	cd g95-${MY_VERSION}
	MY_LIB_VERSION="$MY_VERSION"
	econf --prefix=/usr/local --with-gcc-dir="${WORKDIR}/gcc-${MY_GCC_VERSION}" \
	  || die "configure g95 failed"
	emake || die "emake g95 failed"
	cd "${WORKDIR}/g95-${MY_VERSION}/libf95.a-${MY_LIB_VERSION}"
	econf --prefix=/usr/local --with-gcc-dir="${WORKDIR}/gcc-${MY_GCC_VERSION}" \
	  || die "configure libf95 failed"
	emake || die "emake libf95 failed"
}

src_install() {
	cd "${WORKDIR}"
	MY_VERSION=`ls -d g95-*`
	MY_VERSION=${MY_VERSION#g95-}
	if [ "X$MY_VERSION" != "X$PV" ]; then ewarn "Version changed from ${PV} \
	  to ${MY_VERSION}"; fi
	cd g95-${MY_VERSION}
	MY_LIB_VERSION="$MY_VERSION"
	make install DESTDIR="${D}"
	cd "${WORKDIR}/g95-${MY_VERSION}/libf95.a-${MY_LIB_VERSION}"
	make install DESTDIR="${D}"
}

