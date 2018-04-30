# Copyright 1999-2018 Gentoo Foundation
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
		-e "s:_DESTINATION=/usr/local/lib:_DESTINATION=${D}usr/lib64:" \
		-e "s:_DESTINATION=/usr/local/:_DESTINATION=${D}usr/:" \
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
	mkdir -p "${D}/usr/bin" "${D}/usr/include" "${D}/usr/lib64" "${D}/usr/share" "${D}/opt" "${D}/lib/udev/rules.d"

	VERSION=`head -n 100 labjack_ljm_installer.run | grep scriptargs= | sed -e 's/scriptargs=//' -e 's/"//g'`  # v2017_12_21_x86_64 has LJM library v1.17.0
	elog "${P} contains LJM library ${VERSION}"
	./setup.sh ${VERSION}

	# Install examples if desired:
	if use examples; then
		insinto usr/share/LabJack
		doins -r labjack_ljm_examples
	fi

	# Do NOT install kipling if explicitly indicated:
	if ! use kipling; then
		rm -rf "${D}/opt/" "${D}/usr/bin/"
	fi
}

pkg_postinst() {
	elog
	elog "Please manually restart the device rules, e.g. using "
	elog "  'udevadm control --reload'  or restart your computer."
	elog
	elog "If you have any LabJack devices connected, please disconnect and"
	elog "  reconnect them afterwards for device rule changes to take effect"
	elog " (or use 'udevadm trigger')."
	elog
}
