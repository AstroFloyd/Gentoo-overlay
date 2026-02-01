# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit git-r3 udev

DESCRIPTION="This program allows you read and control device brightness."
HOMEPAGE="https://github.com/Hummer12007/brightnessctl"
EGIT_REPO_URI="https://github.com/Hummer12007/brightnessctl"

if [[ ${PV} = 9999 ]] ; then
	EGIT_COMMIT=""
else
	EGIT_COMMIT="${PV}"
fi

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="systemd udev"

DEPEND="
systemd? ( sys-apps/systemd:= )
udev? ( virtual/udev )
"
RDEPEND="${DEPEND}"

src_configure() {
	# Cannot use econf, as it produces default options like --build=, which are not supported by configure:
	if use systemd; then
		./configure --enable-logind --disable-udev --prefix=/usr
	elif use udev; then
		./configure --disable-logind --enable-udev --prefix=/usr
	else
		./configure --disable-logind --enable-udev --prefix=/usr
	fi
}

pkg_postinst() {
	udev_reload
}
pkg_postrm() {
	udev_reload
}
