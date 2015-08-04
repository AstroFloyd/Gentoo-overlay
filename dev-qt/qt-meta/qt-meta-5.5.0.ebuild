# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-qt/qt-meta/qt-meta-4.8.5.ebuild,v 1.6 2015/04/01 18:52:12 pesa Exp $

EAPI=5

DESCRIPTION="Cross-platform application development framework (metapackage)"
HOMEPAGE="https://www.qt.io/"

LICENSE="metapackage"
SLOT="4"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="+dbus kde +webkit"

DEPEND=""
RDEPEND="
	>=dev-qt/assistant-${PV}:5
	>=dev-qt/designer-${PV}:5
	>=dev-qt/linguist-${PV}:5
	>=dev-qt/pixeltool-${PV}:5
	dbus? ( >=dev-qt/qdbusviewer-${PV}:5 )
	>=dev-qt/qtcore-${PV}:5
	dbus? ( >=dev-qt/qtdbus-${PV}:5 )
	>=dev-qt/qtdeclarative-${PV}:5
	>=dev-qt/qtgui-${PV}:5
	>=dev-qt/qthelp-${PV}:5
	>=dev-qt/qtmultimedia-${PV}:5
	>=dev-qt/qtopengl-${PV}:5
	kde? ( media-libs/phonon[qt5] )
	>=dev-qt/qtscript-${PV}:5
	>=dev-qt/qtsql-${PV}:5
	>=dev-qt/qtsvg-${PV}:5
	>=dev-qt/qttest-${PV}:5
	webkit? ( >=dev-qt/qtwebkit-${PV}:5 )
	>=dev-qt/qtxmlpatterns-${PV}:5
"
