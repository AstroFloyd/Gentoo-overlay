# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit git-r3 cmake

DESCRIPTION="SASL plugin for client-side OAuth 2.0, e.g. Gmail/Outlook/Office/Postfix SMTP"
HOMEPAGE="https://github.com/tarickb/sasl-xoauth2"
SRC_URI=""

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

EGIT_REPO_URI="https://github.com/tarickb/sasl-xoauth2.git"

DEPEND=""
RDEPEND="${DEPEND}"

src_install() {
	dobin scripts/sasl-xoauth2-tool
	dolib.so "$BUILD_DIR/src/libsasl-xoauth2.so"
	insinto /etc
	doins src/sasl-xoauth2.conf
	dodoc ChangeLog README.md
}
