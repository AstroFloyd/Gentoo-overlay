# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="LabJackM driver + C library and Kipling for LabJack T4, T7, and Digit (64-bit)"
HOMEPAGE="https://labjack.com/support/software/installers/ljm"
SRC_URI="https://labjack.com/sites/default/files/software/labjack_ljm_software_2017_12_21_x86_64.tar.gz"

LICENSE="LabJack Boost-1.0 LGPL-2.1 MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="examples +kipling"

DEPEND="app-arch/unmakeself
		kipling? ( gnome-base/gconf )
		"
RDEPEND="${DEPEND}"

S="${WORKDIR}/labjack_ljm_software_2017_12_21_x86_64"

src_prepare() {
	eapply_user

	# Unpack selfextracting tarball:
	unmakeself labjack_ljm_installer.run

	# Fix destination directories:
	sed -i \
		-e "s:_DESTINATION=/usr/local/lib:_DESTINATION=${PORTAGE_BUILDDIR}/image/usr/lib64:" \
		-e "s:_DESTINATION=/usr/local/:_DESTINATION=${PORTAGE_BUILDDIR}/image/usr/:" \
		-e "s:_DESTINATION=/opt:_DESTINATION=${PORTAGE_BUILDDIR}/image/opt:" \
		-e "s:/lib/udev/rules.d:${PORTAGE_BUILDDIR}/image/lib/udev/rules.d:" \
		setup.sh

	# Don't clean up.  Print messages in success() in pkg_info():
	sed -i 's:go rm -rf "./labjack_ljm_software":echo "The package was installed succesfully"; exit 0  # \&:' setup.sh

	# The library path is added to /etc/ld.so.conf and ldconfig is run, but since we use the default dir (/usr/lib64/), this isn't necessary:
	sed -i 's:^setup_ldconfig$:# setup_ldconfig:' setup.sh

	# Cannot restart device rules at this stage:
	sed -i 's:^restart_device_rules$:# restart_device_rules:' setup.sh

	# Remove path from symbolic links in the same directory:
	sed -i \
		-e 's:ln -s -f ${LIB_DESTINATION}/${LJM_REALNAME} ${LIB_DESTINATION}/${LJM_SONAME}:ln -s -f ${LJM_REALNAME} ${LIB_DESTINATION}/${LJM_SONAME}:' \
		-e 's:ln -s -f ${LIB_DESTINATION}/${LJM_SONAME} ${LIB_DESTINATION}/${LJM_LINKERNAME}:ln -s -f ${LJM_SONAME} ${LIB_DESTINATION}/${LJM_LINKERNAME}:' \
		setup.sh

	# Portage now refuses world-writable files and directories.  This should be reported at the end:
	# sed -i \
	# 	-e 's| --mode=777 | --mode=755 |' \
	# 	-e 's|chmod 777 |chmod 755 |' \
	# 	-e 's| chmod 666 | chmod 644 |' \
	# 	-e 's|chmod a+rw |chmod 644 |' \
	# 	setup.sh

}

src_install() {
	## Note: installing in /usr/bin, /usr/lib, /usr/include and /usr/share doesn't work, since the /usr/local/... is hardcoded in some of the binaries...
	mkdir -p "${PORTAGE_BUILDDIR}/image/usr/bin" "${PORTAGE_BUILDDIR}/image/usr/include" "${PORTAGE_BUILDDIR}/image/usr/lib64" "${PORTAGE_BUILDDIR}/image/usr/share" "${PORTAGE_BUILDDIR}/image/opt" "${PORTAGE_BUILDDIR}/image/lib/udev/rules.d"

	VERSION=`head -n 100 labjack_ljm_installer.run | grep scriptargs= | sed -e 's/scriptargs=//' -e 's/"//g'`  # v2017_12_21_x86_64 has LJM library v1.17.0
	elog "${P} contains LJM library ${VERSION}"
	elog "Running LabJack setup script..."
	./setup.sh ${VERSION} || die
	elog "Exiting LabJack setup script..."

	# Remove symlink to non-existing target:
	rm -f "${PORTAGE_BUILDDIR}/image/opt/labjack_kipling/node_modules/.bin/ncp"

	# Install header files for examples to /usr/include, so that they can be used elsewhere:
	insinto usr/include
	doins labjack_ljm_examples/LabJackMModbusMap.h labjack_ljm_examples/examples/LJM_Utilities.h labjack_ljm_examples/examples/stream/LJM_StreamUtilities.h
	chmod a-x "${PORTAGE_BUILDDIR}/image/usr/include/LabJackM.h"  # Fix permissions

	# Install examples if desired:
	if use examples; then
		elog "Copying examples..."
		insinto usr/share/LabJack
		doins -r labjack_ljm_examples
	fi

	# Do NOT install kipling if explicitly indicated with the -kipling USE flag:
	use kipling || rm -rf "${PORTAGE_BUILDDIR}/image/opt/" "${PORTAGE_BUILDDIR}/image/usr/bin/"

	# Create symlinks from /usr/... to /usr/local/... so that things actually work:
	mkdir -p "${PORTAGE_BUILDDIR}/image/usr/local/bin" "${PORTAGE_BUILDDIR}/image/usr/local/include" "${PORTAGE_BUILDDIR}/image/usr/local/lib64" "${PORTAGE_BUILDDIR}/image/usr/local/share"
	MAJOR_VERSION=`echo ${VERSION} | sed 's:^\(.*\)\..*\..*$:\1:'`
	use kipling && dosym ../../bin/labjack_kipling usr/local/bin/labjack_kipling

	dosym ../../lib64/libLabJackM.so usr/local/lib64/libLabJackM.so
	dosym ../../lib64/libLabJackM.so.${MAJOR_VERSION} usr/local/lib64/libLabJackM.so.${MAJOR_VERSION}
	dosym ../../lib64/libLabJackM.so.${VERSION} usr/local/lib64/libLabJackM.so.${VERSION}

	dosym ../../include/LabJackM.h usr/local/include/LabJackM.h
	dosym ../../include/LabJackMModbusMap.h usr/local/include/LabJackMModbusMap.h
	dosym ../../include/LJM_StreamUtilities.h usr/local/include/LJM_StreamUtilities.h
	dosym ../../include/LJM_Utilities.h usr/local/include/LJM_Utilities.h

	dosym ../../share/LabJack usr/local/share/LabJack

	# Does not seem to work:
	strip --strip-unneeded -R .comment -R .GCC.command.line -R .note.gnu.gold-version \
		  "${PORTAGE_BUILDDIR}/image/opt/labjack_kipling/Kipling" "${PORTAGE_BUILDDIR}/image/opt/labjack_kipling/core" "${PORTAGE_BUILDDIR}/image/usr/lib64/libLabJackM.so.${VERSION}"
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
	elog "  directory /usr/share/LabJack/"
	elog
	elog "labjack-ljm expects to be installed in /usr/local/, rather than /usr/."
	elog "This has been hard-coded in some of the binaries, and moving files will"
	elog "  result in a defunct package."
}
