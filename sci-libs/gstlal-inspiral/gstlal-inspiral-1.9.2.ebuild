# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="A gstreamer library for the LIGO Analysis Language"
HOMEPAGE="https://lscsoft.docs.ligo.org/gstlal/"
SRC_URI="http://software.ligo.org/lscsoft/source/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc +fast-install libtool-lock +openmp static-libs"  #  gtk-doc-html gtk-doc-pdf gtk-doc introspection +massmodel

RDEPEND=">=dev-lang/python-3:*
		 dev-libs/glib
		 dev-libs/openssl
		 media-libs/gst-plugins-base
		 media-libs/gstreamer
		 sci-libs/fftw
		 sci-libs/gsl
		 sci-libs/gstlal
		 sci-libs/hdf5
		 sci-libs/lalburst
		 sci-libs/lalframe
		 sci-libs/lalinspiral
		 sci-libs/lalmetaio
		 sci-libs/lalsimulation
		 sci-libs/lal
		 sci-libs/ldas-tools-al
		 sci-libs/ldas-tools-framecpp
		 sci-libs/metaio
		 sys-libs/zlib
"
DEPEND=${RDEPEND}

src_configure() {
	econf \
		$(use_enable fast-install) \
		$(use_enable doc gtk-doc-html) \
		$(use_enable libtool-lock) \
		$(use_enable openmp) \
		$(use_enable static-libs static) \
		--disable-gtk-doc-html \
		--disable-gtk-doc-pdf \
		--disable-massmodel
		# $(use_enable massmodel) \  # Requires lnP_template_signal_BBH_logm_reweighted_mchirp.hdf5
		# $(use_enable introspection) \
		# gtk-doc-html gtk-doc-pdf
}

src_install() {
	emake DESTDIR="${D}${DESTDIR}" install
}
