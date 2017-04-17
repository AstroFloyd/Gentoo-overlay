# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

DESCRIPTION="Binary version of VMware horizon client"
HOMEPAGE="https://my.vmware.com/web/vmware/info/slug/desktop_end_user_computing/vmware_horizon_clients/4_0"
SRC_URI="https://download3.vmware.com/software/view/viewclients/CART16Q4/VMware-Horizon-Client-4.3.0-4710754.x64.bundle"

LICENSE="vmware"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND=""
RDEPEND=""

src_unpack() {
	mkdir "${S}"               # Create source dir
	cp "${DISTDIR}/${A} ${S}"  # Copy the distfile to the source dir - symlink won't execute
	chmod +x "${S}/${A}"       # Make the distfile executable
	cd "${S}"
	./${A} -x extract/
}

src_prepare() {
	# Arch PKGBUILD build() function:

	# This is a dirty hack, but it works.
	# Change dynamic section in ELF files to fix dynamic linking.
	# Make sure the length is not changed!
	#	libudev.so.0 -> libudev.so.1
	#
	# for system openssl:
	#	libssl.so.1.0.[12] -> libssl.so.1.0.0
	#	libcrypto.so.1.0.[12] -> libcrypto.so.1.0.0
	#
	# for bundled openssl - we use uncommon name to make sure no other application will care:
	#	libssl.so.1.0.[12] -> libssl-vmw.so.0
	#	libcrypto.so.1.0.[12] -> libcrypto-vmw.so.0

	cd extract
	for bundle in vmware-horizon-*; do
		echo "Patching ${bundle}..."
		for FILE in $(find "${bundle}" -type f); do
			# executables and libraries only
			file --mime "${FILE}" | egrep -q "(application/x-(executable|sharedlib)|text/x-shellscript)" || continue

			# make executable
			chmod +x "${FILE}"

			# ELF executables and libraries only
			file --mime "${FILE}" | egrep -q "application/x-(executable|sharedlib)" || continue

			# link against libudev.so.1
			sed -i -e 's/libudev.so.0/libudev.so.1/' "${FILE}"

			# even openssl 1.0.[12].x has library file names ending in .so.1.0.0
			if [ ${_USE_BUNDLED_OPENSSL:=0} -eq 0 -o "${bundle}" = 'vmware-horizon-client' ]; then
				sed -i -e 's/libssl.so.1.0.[12]/libssl.so.1.0.0/' \
					-e 's/libcrypto.so.1.0.[12]/libcrypto.so.1.0.0/' \
					"${FILE}"
			else
				# Some files link against openssl...
				# Use the bundled version there.
				sed -i -e 's/libssl.so.1.0.[012]/libssl-vmw.so.0/' \
					-e 's/libcrypto.so.1.0.[012]/libcrypto-vmw.so.0/' \
					"${FILE}"
			fi
		done
	done

	# now that we fixed dynamic linking, remove the libraries provided by the package...
	rm -f vmware-horizon-pcoip/pcoip/lib/vmware/lib{crypto,ssl}.so.1.0.2
}

src_install() {
	# Following the Arch Linux package build for v4.1.0

	# Client:
	cd "${S}/extract/vmware-horizon-client/"
	dobin bin/*
	exeinto usr/lib/vmware/view/bin/
	doexe lib/vmware/view/bin/vmware-view
	insinto usr/share
	doins -r share/*
	dodoc doc/*
	dodoc debug/*

	# PCOIP:
	cd "${S}/extract/vmware-horizon-pcoip/pcoip/"
	dobin bin/*
	insinto usr/lib/
	doins -r lib/*

	# Real-time audio/video:
	cd "${S}/extract/vmware-horizon-rtav/"
	insinto usr/lib/
	doins -r lib/*

	# Smartcard:
	cd "${S}/extract/vmware-horizon-smartcard/"
	insinto usr/lib/
	doins -r lib/*

	# USB redirection:
	cd "${S}/extract/vmware-horizon-usb/"
	exeinto usr/lib/vmware/view/usb/
	doexe bin/*
	dosym /usr/lib/vmware/view/usb/vmware-view-usbd usr/bin/
	dosym /usr/lib/vmware/view/usb/vmware-usbarbitrator usr/bin/
	# Note: no init scripts

	# Virtual printing:
	cd "${S}/extract/vmware-horizon-virtual-printing/"
	exeinto usr/lib/vmware/view/usb/
	doexe bin/*
	dobin bin/x86_64-linux-NOSSL/thnu*  # Specific for amd64
	exeinto etc/thnuclnt/
	doexe bin/x86_64-linux-NOSSL/.thnumod  # Specific for amd64
	exeinto usr/lib/vmware/rdpvcbridge/
	doexe lib/tprdp.so
	insinto usr/share/cups/mime/
	doins bin/conf/thnuclnt.convs bin/conf/thnuclnt.types
	# Note: no Arch service file
}

pkg_postinst() {
	ewarn "This is an experimental ebuild.  Use at your own risk!"
}
