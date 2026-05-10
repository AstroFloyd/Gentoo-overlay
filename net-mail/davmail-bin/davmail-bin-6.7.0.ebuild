# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit java-pkg-2 xdg-utils desktop

MY_PN="davmail"
MY_REV="4068"

DESCRIPTION="POP/IMAP/SMTP/CalDAV/CardDAV/LDAP Exchange and Office 365 Gateway"
HOMEPAGE="https://davmail.sourceforge.net/"
SRC_URI="https://downloads.sourceforge.net/${MY_PN}/${MY_PN}-${PV}-${MY_REV}.zip"

S="${WORKDIR}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="server"

RESTRICT="mirror"

# DavMail 6.x requires Java 11+.
DEPEND="
	>=virtual/jre-11:*
"
RDEPEND="
	${DEPEND}
"
BDEPEND="
	app-arch/unzip
"

# The upstream zip unpacks into a flat directory named davmail-<version>.
src_unpack() {
	unzip -q "${DISTDIR}/${MY_PN}-${PV}-${MY_REV}.zip" || die "unzip failed"
}

src_prepare() {
	default
}

src_install() {
	# Install all jar libraries.
	java-pkg_dojar lib/*.jar
	java-pkg_dojar ${MY_PN}.jar

	# Icon (must be provided in ${FILESDIR}).
	doicon "${FILESDIR}/${MY_PN}.png"

	# Wrapper script to launch DavMail.
	java-pkg_dolauncher ${MY_PN} --main davmail.DavGateway

	# Desktop entry for graphical (non-server) use.
	if ! use server; then
		make_desktop_entry ${MY_PN} "DavMail Gateway" \
			"/usr/share/pixmaps/${MY_PN}.png" "Network"
	fi

	if use server; then
		# Log file placeholder — owned by the davmail user.
		touch ${MY_PN}.log
		insinto /var/log
		doins ${MY_PN}.log
		fowners ${MY_PN}:${MY_PN} /var/log/${MY_PN}.log

		# Default properties file — copy/edit before first start.
		insinto /etc
		doins "${FILESDIR}/${MY_PN}.properties"

		# OpenRC init and conf files (provide in ${FILESDIR}).
		newinitd "${FILESDIR}/${MY_PN}.init" ${MY_PN}
		newconfd "${FILESDIR}/${MY_PN}.conf" ${MY_PN}
	fi
}

pkg_postinst() {
	xdg_icon_cache_update

	if use server; then
		elog
		elog "DavMail is installed as a system service."
		elog "Before starting it, review and adjust /etc/${MY_PN}.properties."
		elog
		elog "For Office 365 / Exchange Online you will need to set:"
		elog "  ${MY_PN}.mode=O365Modern   (or O365Manual for headless first-run)"
		elog "  ${MY_PN}.url=https://outlook.office365.com/EWS/Exchange.asmx"
		elog "  ${MY_PN}.server=true"
		elog
		elog "For the initial OAuth2 token, run davmail once interactively as your"
		elog "own user with O365Manual mode, authenticate in the browser, then"
		elog "switch back to O365Modern and start the OpenRC service:"
		elog "  rc-service ${MY_PN} start"
		elog "  rc-update add ${MY_PN} default"
		elog
	fi
}

pkg_postrm() {
	xdg_icon_cache_update
}
