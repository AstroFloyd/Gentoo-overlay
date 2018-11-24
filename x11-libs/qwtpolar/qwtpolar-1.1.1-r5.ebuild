# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit multibuild multilib qmake-utils

DESCRIPTION="Library for displaying values on a polar coordinate system"
HOMEPAGE="http://qwtpolar.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="qwt"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="designer doc examples qt4 qt5"
REQUIRED_USE="|| ( qt4 qt5 )"

RDEPEND="x11-libs/qwt:6[svg]
		 qt5? ( >=x11-libs/qwt-6.1.3-r2[svg] )"
DEPEND="${RDEPEND}"

src_prepare() {
	rm -f "${S}/doc/man/man3/qwtlicense.3"  # Already provided by dependency x11-libs/qwt
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
	INCLUDEPATH += "${EPREFIX}/usr/include/qwt6"
	LIBS += -L"${S}/$(get_libdir)"
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
					-e "/^TARGET/s:(qwtpolar):(qwtpolar-qt4):g" \
					-e "/^TARGET/s:qwtpolar):qwtpolar-qt4):g" \
					-i src/src.pro || die

				sed \
					-e '/qwtPolarAddLibrary/s:(qwtpolar):(qwtpolar-qt4):g' \
					-e '/qwtPolarAddLibrary/s:qwtpolar):qwtpolar-qt4):g' \
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
				# qmake 5 doesn't seem to find Qwt - not sure why, but fix it by hand...
				make sub-src-qmake_all
				sed -i '/LIBS /s/$(SUBLIBS)/$(SUBLIBS) -lqwt6-qt5/' src/Makefile
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
	mv "${D}/usr/share/doc/${PN}-${PVR}/man" "${D}/usr/share"

	if use examples; then
		# don't build examples - fix the Qt files to allow build once installed
		cat > examples/examples.pri <<-EOF
TEMPLATE     = app

unix:  include( "${EPREFIX}/usr/share/qt4/mkspecs/features/qwt.prf" )
unix:  include( "${EPREFIX}/usr/share/qt4/mkspecs/features/qwtpolar.prf" )

greaterThan(QT_MAJOR_VERSION, 4): QT += printsupport concurrent

contains(QWT_POLAR_CONFIG, QwtPolarSvg) {
   QT += svg
} else {
   DEFINES += QWT_POLAR_NO_SVG
}
		EOF
		if use qt4; then
			insinto /usr/share/${PN}-qt4
			doins -r examples
		fi
		if use qt5; then
			sed -i -e 's/qt4/qt5/g' examples/examples.pri || die
			insinto /usr/share/${PN}-qt5
			doins -r examples
		fi
	fi
}
