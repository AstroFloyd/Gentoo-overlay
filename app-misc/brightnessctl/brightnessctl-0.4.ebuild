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
IUSE="udev"

DEPEND="
udev? ( virtual/udev )
"
RDEPEND="${DEPEND}"

src_install() {
	local myconf
	if use udev ; then
		myconf="${myconf} INSTALL_UDEV_RULES=1"
	else
		myconf="${myconf} INSTALL_UDEV_RULES=0"
	fi

	emake install ${myconf} DESTDIR="${D}"
}

pkg_postinst() {
	udev_reload
}
pkg_postrm() {
	udev_reload
}
