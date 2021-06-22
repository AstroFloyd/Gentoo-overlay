# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit versionator rpm

MY_PN="skychart"
MY_PV=$(replace_version_separator 2 -)
DESCRIPTION="Free software to draw sky charts, also known as Cartes du Ciel"
HOMEPAGE="http://www.ap-i.net/skychart/"
SRC_URI="
	x86? ( mirror://sourceforge/skychart/${MY_PN}-${MY_PV}-linux_i386.tar.bz2 )
	amd64? ( mirror://sourceforge/skychart/${MY_PN}-${MY_PV}-linux_x86_64.tar.bz2 )
	mirror://sourceforge/skychart/skychart-data-stars-3.1-1466.noarch.rpm
	mirror://sourceforge/skychart/skychart-data-dso-3.1-1466.noarch.rpm"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE="xplanet"

RESTRICT="strip"

RDEPEND=">=x11-libs/gtk+-2.0
	xplanet? ( x11-misc/xplanet )"
S="${WORKDIR}/skychart"

src_unpack() {
	if [ "${ARCH}" = "amd64" ] ; then
		XARCH="x86_64"
	else
		XARCH="i386"
	fi

	unpack ${MY_PN}-${MY_PV}-linux_$XARCH.tar.bz2
	rpm_unpack skychart-data-stars-3.1-1466.noarch.rpm
	rpm_unpack skychart-data-dso-3.1-1466.noarch.rpm
}

src_install () {
	# install catalogs
	mv "${WORKDIR}"/usr/share/skychart/cat/bsc5* "${WORKDIR}"/skychart/share/skychart/cat/bsc5/
	mv "${WORKDIR}"/usr/share/skychart/cat/ngc2000/* "${WORKDIR}"/skychart/share/skychart/cat/ngc2000/
	rm -rf "${WORKDIR}"/usr/share/skychart/cat/bsc5
	rm -rf "${WORKDIR}"/usr/share/skychart/cat/ngc2000
	mv "${WORKDIR}"/usr/share/skychart/cat/* "${WORKDIR}"/skychart/share/skychart/cat/

	local installdir="/opt/${MY_PN}"

	dodir "${installdir}" || die "Creating dir failed."
	insinto "${installdir}"
	doins -r lib share || die "Copying files failed."
	exeinto "${installdir}/bin"
	doexe bin/* || die "Copying files failed."

	dodir /usr/$(get_libdir)
	dosym /opt/skychart/lib/libplan404.so /usr/$(get_libdir)
	dosym /opt/skychart/lib/libgetdss.so /usr/$(get_libdir)

	for f in skychart cdcicon varobs varobs_lpv_bulletin; do
		newbin "${FILESDIR}/${f}.sh" "${f}" || die "newbin for ${f} failed."
	done

	newicon "${D}"/opt/skychart/share/pixmaps/skychart.png skychart.png
	domenu "${FILESDIR}"/skychart.desktop
}
