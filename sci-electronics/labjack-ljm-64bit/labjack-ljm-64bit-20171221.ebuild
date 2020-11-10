# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

DESCRIPTION="LabJackM driver + C library and Kipling for LabJack T4, T7, and Digit (64-bit)"
HOMEPAGE="https://labjack.com/support/software/installers/ljm"
SRC_URI="https://labjack.com/sites/default/files/software/labjack_ljm_software_2017_12_21_x86_64.tar.gz"

LICENSE="LabJack Boost-1.0 LGPL-2.1 MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="examples +kipling"

DEPEND="app-arch/unmakeself"
RDEPEND="${DEPEND}"

S="${WORKDIR}/labjack_ljm_software_2017_12_21_x86_64"

src_prepare() {
	# Unpack selfextracting tarball:
	unmakeself labjack_ljm_installer.run

	# Fix destination directories:
	sed -i \
		-e "s:_DESTINATION=/usr/local/lib:_DESTINATION=${D}usr/local/lib64:" \
		-e "s:_DESTINATION=/usr/local/:_DESTINATION=${D}usr/local/:" \
		-e "s:_DESTINATION=/opt:_DESTINATION=${D}opt:" \
		-e "s:/lib/udev/rules.d:${D}lib/udev/rules.d:" \
		setup.sh

	# Don't clean up.  Print messages in success() in pkg_info():
	sed -i 's:go rm -rf "./labjack_ljm_software":echo "The packages was installed succesfully"; exit 0  # \&:' setup.sh

	# The library path is added to /etc/ld.so.conf and ldconfig is run, but since we use the default dir (/usr/lib64/), this isn't necessary:
	sed -i 's:^setup_ldconfig$:# setup_ldconfig:' setup.sh

	# Cannot restart device rules at this stage:
	sed -i 's:^restart_device_rules$:# restart_device_rules:' setup.sh

	# Remove path from symbolic links in the same directory:
	sed -i \
		-e 's:ln -s -f ${LIB_DESTINATION}/${LJM_REALNAME} ${LIB_DESTINATION}/${LJM_SONAME}:ln -s -f ${LJM_REALNAME} ${LIB_DESTINATION}/${LJM_SONAME}:' \
		-e 's:ln -s -f ${LIB_DESTINATION}/${LJM_SONAME} ${LIB_DESTINATION}/${LJM_LINKERNAME}:ln -s -f ${LJM_SONAME} ${LIB_DESTINATION}/${LJM_LINKERNAME}:' \
		setup.sh
}

src_install() {
	# Note: installing in /usr/bin, /usr/lib, /usr/include and /usr/share doesn't work, since the /usr/local/... is hardcoded in some of the binaries...
	mkdir -p "${D}/usr/local/bin" "${D}/usr/local/include" "${D}/usr/local/lib64" "${D}/usr/local/share" "${D}/opt" "${D}/lib/udev/rules.d"

	VERSION=`head -n 100 labjack_ljm_installer.run | grep scriptargs= | sed -e 's/scriptargs=//' -e 's/"//g'`  # v2017_12_21_x86_64 has LJM library v1.17.0
	elog "${P} contains LJM library ${VERSION}"
	elog "Running LabJack setup script..."
	./setup.sh ${VERSION} || die
	elog "Exiting LabJack setup script..."

	# Remove symlink to non-existing target:
	rm -f "${D}/opt/labjack_kipling/node_modules/.bin/ncp"

	# Install header files for examples to /usr/local/include, so that they can be used elsewhere:
	insinto usr/local/include
	doins labjack_ljm_examples/LabJackMModbusMap.h labjack_ljm_examples/examples/LJM_Utilities.h labjack_ljm_examples/examples/stream/LJM_StreamUtilities.h
	chmod a-x "${D}usr/local/include/LabJackM.h"  # Fix permissions

	# Install examples if desired:
	if use examples; then
		insinto usr/local/share/LabJack
		doins -r labjack_ljm_examples
	fi

	# Do NOT install kipling if explicitly indicated:
	use kipling || rm -rf "${D}/opt/" "${D}/usr/local/bin/"

	# Create symlinks from /usr/local/... to /usr/... so that the user can find stuff:
	mkdir -p "${D}/usr/bin" "${D}/usr/include" "${D}/usr/lib64" "${D}/usr/share"
	MAJOR_VERSION=`echo ${VERSION} | sed 's:^\(.*\)\..*\..*$:\1:'`
	use kipling && dosym ../local/bin/labjack_kipling usr/bin/labjack_kipling

	dosym ../local/lib64/libLabJackM.so usr/lib64/libLabJackM.so
	dosym ../local/lib64/libLabJackM.so.${MAJOR_VERSION} usr/lib64/libLabJackM.so.${MAJOR_VERSION}
	dosym ../local/lib64/libLabJackM.so.${VERSION} usr/lib64/libLabJackM.so.${VERSION}

	dosym ../local/include/LabJackM.h usr/include/LabJackM.h
	dosym ../local/include/LabJackMModbusMap.h usr/include/LabJackMModbusMap.h
	dosym ../local/include/LJM_StreamUtilities.h usr/include/LJM_StreamUtilities.h
	dosym ../local/include/LJM_Utilities.h usr/include/LJM_Utilities.h

	dosym ../local/share/LabJack usr/share/LabJack
}

pkg_postinst() {
	elog
	elog "You may have to manually restart the device rules, e.g. using "
	elog "  'udevadm control --reload'  or restart your computer."
	elog
	elog "If you have any LabJack devices connected, please disconnect and"
	elog "   reconnect them afterwards for device rule changes to take effect"
	elog "  (or use 'udevadm trigger')."
	elog
	elog "Note that (user) settings will be saved in the world writable"
	elog "  directory /usr/local/share/LabJack/"
	elog
}

pkg_prerm() {
	elog "Removing /usr/share/LabJack symlink to avoid searching all installed packages for files installed via above symlink(s)..."
	rm -f /usr/share/LabJack
}

pkg_postrm() {
	elog "Removing /usr/local/share/LabJack/ so that no settings remain"
	rm -rf /usr/local/share/LabJack
}
