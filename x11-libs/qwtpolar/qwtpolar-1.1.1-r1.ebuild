# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit multibuild multilib qmake-utils

DESCRIPTION="Library for displaying values on a polar coordinate system"
HOMEPAGE="http://qwtpolar.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="qwt"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="designer doc qt4 qt5"
REQUIRED_USE="|| ( qt4 qt5 )"

RDEPEND="x11-libs/qwt:6[svg]
		 qt5? ( >=x11-libs/qwt-6.1.2-r1[svg,qt5] )"
DEPEND="${RDEPEND}"

src_prepare() {
	sed \
		-e "/QWT_POLAR_INSTALL_PREFIX /s:=.*$:= ${EPREFIX}/usr:g" \
		-e "/QWT_POLAR_INSTALL_LIBS/s:lib:$(get_libdir):g" \
		-e "/QWT_POLAR_INSTALL_DOCS/s:doc:share/doc/${PF}:g" \
		-e "/= QwtPolarExamples/d" \
		-i ${PN}config.pri || die

	use designer || sed -e "/= QwtPolarDesigner/ d" -i ${PN}config.pri || die
	use doc      || sed -e 's/target doc/target/'   -i src/src.pro     || die

	sed \
		-e "s:{QWT_POLAR_ROOT}/lib:{QWT_POLAR_ROOT}/$(get_libdir):" \
		-i src/src.pro || die
	echo "INCLUDEPATH += ${EPREFIX}/usr/include/qwt6" >> src/src.pro
	cat >> designer/designer.pro <<- EOF
	INCLUDEPATH += "${EPREFIX}"/usr/include/qwt6
	LIBS += -L"${S}"/$(get_libdir)
	EOF

	MULTIBUILD_VARIANTS=( )

	if use qt4; then
		MULTIBUILD_VARIANTS+=( qt4-shared )
	fi
	if use qt5; then
		MULTIBUILD_VARIANTS+=( qt5-shared )
	fi

	multibuild_copy_sources

	qt45_preparation() {
		case "${MULTIBUILD_VARIANT}" in
			qt4-*)
				sed \
					-e "/QWT_POLAR_INSTALL_PLUGINS/s:=.*$:= ${EPREFIX}/usr/$(get_libdir)/qt4/plugins/designer/:g" \
					-e "/QWT_POLAR_INSTALL_FEATURES/s:=.*$:= ${EPREFIX}/usr/share/qt4/mkspecs/features/:g" \
					-i ${PN}config.pri || die

				sed \
					-e "/^TARGET/s:(qwtpolar):(qwtpolar6-qt4):g" \
					-e "/^TARGET/s:qwtpolar):qwtpolar6-qt4):g" \
					-i src/src.pro || die

				sed \
					-e '/qwtPolarAddLibrary/s:(qwtpolar):(qwtpolar6-qt4):g' \
					-e '/qwtPolarAddLibrary/s:qwtpolar):qwtpolar6-qt4):g' \
					-e "s:\${QWT_POLAR_ROOT}/lib:\${QWT_POLAR_ROOT}/$(get_libdir):g" \
					-i qwtpolar.prf designer/designer.pro examples/examples.pri || die
				;;
			qt5-*)
				sed \
					-e "/QWT_POLAR_INSTALL_PLUGINS/s:=.*$:= ${EPREFIX}/usr/$(get_libdir)/qt5/plugins/designer/:g" \
					-e "/QWT_POLAR_INSTALL_FEATURES/s:=.*$:= ${EPREFIX}/usr/share/qt5/mkspecs/features/:g" \
					-i ${PN}config.pri || die

				sed \
					-e "/^TARGET/s:(qwtpolar):(qwtpolar-qt5):g" \
					-e "/^TARGET/s:qwtpolar):qwtpolar-qt5):g" \
					-i src/src.pro || die

				sed \
					-e '/qwtPolarAddLibrary/s:(qwtpolar):(qwtpolar-qt5):g' \
					-e '/qwtPolarAddLibrary/s:qwtpolar):qwtpolar-qt5):g' \
					-e "s:\${QWT_POLAR_ROOT}/lib:\${QWT_POLAR_ROOT}/$(get_libdir):g" \
					-i qwtpolar.prf designer/designer.pro examples/examples.pri || die
				;;
		esac
	}

	multibuild_foreach_variant run_in_build_dir qt45_preparation
}

src_configure() {
	configuration() {
		case "${MULTIBUILD_VARIANT}" in
			qt4-*)
				eqmake4
				;;
			qt5-*)
				eqmake5
				;;
		esac
	}
	multibuild_parallel_foreach_variant run_in_build_dir configuration
}

src_compile() {
	multibuild_foreach_variant run_in_build_dir default
}

src_install () {
	multibuild_foreach_variant run_in_build_dir emake INSTALL_ROOT="${D}" install
	mv "${D}/usr/share/doc/${PN}-${PVR}/man" "${D}"/usr/share
}
