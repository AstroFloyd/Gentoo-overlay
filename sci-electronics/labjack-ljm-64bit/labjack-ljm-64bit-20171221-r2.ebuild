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

DEPEND="app-arch/unmakeself
		kipling? ( gnome-base/gconf )
		"
RDEPEND="${DEPEND}"

S="${WORKDIR}/labjack_ljm_software_2017_12_21_x86_64"

src_prepare() {
	# Unpack selfextracting tarball:
	unmakeself labjack_ljm_installer.run

	# Fix destination directories:
	sed -i \
		-e "s:_DESTINATION=/usr/local/lib:_DESTINATION=${D}usr/lib64:" \
		-e "s:_DESTINATION=/usr/local/:_DESTINATION=${D}usr/:" \
		-e "s:_DESTINATION=/opt:_DESTINATION=${D}opt:" \
		-e "s:/lib/udev/rules.d:${D}lib/udev/rules.d:" \
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
	mkdir -p "${D}/usr/bin" "${D}/usr/include" "${D}/usr/lib64" "${D}/usr/share" "${D}/opt" "${D}/lib/udev/rules.d"

	VERSION=`head -n 100 labjack_ljm_installer.run | grep scriptargs= | sed -e 's/scriptargs=//' -e 's/"//g'`  # v2017_12_21_x86_64 has LJM library v1.17.0
	elog "${P} contains LJM library ${VERSION}"
	elog "Running LabJack setup script..."
	./setup.sh ${VERSION} || die
	elog "Exiting LabJack setup script..."

	# Remove symlink to non-existing target:
	rm -f "${D}/opt/labjack_kipling/node_modules/.bin/ncp"

	# Install header files for examples to /usr/include, so that they can be used elsewhere:
	insinto usr/include
	doins labjack_ljm_examples/LabJackMModbusMap.h labjack_ljm_examples/examples/LJM_Utilities.h labjack_ljm_examples/examples/stream/LJM_StreamUtilities.h
	chmod a-x "${D}usr/include/LabJackM.h"  # Fix permissions

	# Install examples if desired:
	if use examples; then
		elog "Copying examples..."
		insinto usr/share/LabJack
		doins -r labjack_ljm_examples
	fi

	# Do NOT install kipling if explicitly indicated witg the -kipling USE flag:
	use kipling || rm -rf "${D}/opt/" "${D}/usr/bin/"

	# Create symlinks from /usr/... to /usr/local/... so that things actually work:
	mkdir -p "${D}/usr/local/bin" "${D}/usr/local/include" "${D}/usr/local/lib64" "${D}/usr/local/share"
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
	# elog "labjack-ljm expects to be installed in /usr/local/, rather than /usr/."
	# elog "Hence, you need to set the following symlinks in order for the package to work:"
	# elog
	# elog "ln -s ../../lib64/libLabJackM.so /usr/local/lib64/libLabJackM.so"
	# elog "ln -s ../../lib64/libLabJackM.so.${MAJOR_VERSION} /usr/local/lib64/libLabJackM.so.${MAJOR_VERSION}"
	# elog "ln -s ../../lib64/libLabJackM.so.${VERSION} /usr/local/lib64/libLabJackM.so.${VERSION}"
	# elog
	# elog "ln -s ../../include/LabJackM.h /usr/local/include/LabJackM.h"
	# elog "ln -s ../../include/LabJackMModbusMap.h /usr/local/include/LabJackMModbusMap.h"
	# elog "ln -s ../../include/LJM_StreamUtilities.h /usr/local/include/LJM_StreamUtilities.h"
	# elog "ln -s ../../include/LJM_Utilities.h /usr/local/include/LJM_Utilities.h"
	# elog
	# elog "ln -s ../../share/LabJack /usr/local/share/LabJack"
	# elog
}

# pkg_prerm() {
# 	elog "Removing /usr/share/LabJack symlink to avoid searching all installed packages for files installed via above symlink(s)..."
# 	rm -f /usr/local/share/LabJack
# }
#
# pkg_postrm() {
# 	elog "Removing /usr/share/LabJack/ so that no settings remain"
# 	rm -rf /usr/share/LabJack
# }
