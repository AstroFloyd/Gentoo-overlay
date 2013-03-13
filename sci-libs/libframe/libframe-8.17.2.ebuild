# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="Handle the Frame data format for the gravitational-wave detectors Virgo and LIGO"
HOMEPAGE="http://wwwlapp.in2p3.fr/virgo/FrameL/"
SRC_URI="http://wwwlapp.in2p3.fr/virgo/FrameL/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

#src_compile() {
#	cd "${S}/mgr"
#	./makegcc || die "mgr/makegcc failed"
#}
#
#src_install() {
#	# Install 'manually':
#	MYUNAME=`uname`-`uname -m`  # e.g: "Linux-i686"
#	cd "${S}/${MYUNAME}"
#	dobin FrCheck FrCopy FrDump
#	dolib *.a *.so
#
#	cd ../src
#	insinto /usr/include
#	doins *.h
#}

src_install() {
	#emake install  # Gives access violation
	emake DESTDIR="${D}${DESTDIR}" install
	#dodoc doc/FrDoc.html doc/Spec-Frame-Format-v8.pdf
}


#Install:
# /usr/bin/install -c -m 644 FrDoc.html Spec-Frame-Format-v8.pdf '/usr/share/doc/libframe'
#
# /bin/mkdir -p '/usr/lib64'
# /bin/sh ../libtool   --mode=install /usr/bin/install -c   libFrame.la '/usr/lib64'
#libtool: install: /usr/bin/install -c .libs/libFrame.so.1.3.0 /usr/lib64/libFrame.so.1.3.0
#libtool: install: (cd /usr/lib64 && { ln -s -f libFrame.so.1.3.0 libFrame.so.1 || { rm -f libFrame.so.1 && ln -s libFrame.so.1.3.0 libFrame.so.1; }; })
#libtool: install: (cd /usr/lib64 && { ln -s -f libFrame.so.1.3.0 libFrame.so || { rm -f libFrame.so && ln -s libFrame.so.1.3.0 libFrame.so; }; })
#libtool: install: /usr/bin/install -c .libs/libFrame.lai /usr/lib64/libFrame.la
#libtool: install: /usr/bin/install -c .libs/libFrame.a /usr/lib64/libFrame.a
#libtool: install: chmod 644 /usr/lib64/libFrame.a
#libtool: install: x86_64-pc-linux-gnu-ranlib /usr/lib64/libFrame.a
#Libraries have been installed in:
#   /usr/lib64
#
#
# /bin/mkdir -p '/usr/bin'
#  /bin/sh ../libtool   --mode=install /usr/bin/install -c FrCheck FrCopy FrDump FrDiff FrChannels FrameDataDump FrTrend '/usr/bin'
#libtool: install: /usr/bin/install -c .libs/FrCheck /usr/bin/FrCheck
#libtool: install: /usr/bin/install -c .libs/FrCopy /usr/bin/FrCopy
#libtool: install: /usr/bin/install -c .libs/FrDump /usr/bin/FrDump
#libtool: install: /usr/bin/install -c .libs/FrDiff /usr/bin/FrDiff
#libtool: install: /usr/bin/install -c .libs/FrChannels /usr/bin/FrChannels
#libtool: install: /usr/bin/install -c .libs/FrameDataDump /usr/bin/FrameDataDump
#libtool: install: /usr/bin/install -c .libs/FrTrend /usr/bin/FrTrend
# /bin/mkdir -p '/usr/include'
# /usr/bin/install -c -m 644 FrameL.h FrFilter.h FrIO.h FrVect.h '/usr/include'
# /bin/mkdir -p '/usr/lib64/pkgconfig'
# /usr/bin/install -c -m 644 libframe.pc '/usr/lib64/pkgconfig'
#
# /bin/mkdir -p '/usr/share/libframe/src/matlab'
# /usr/bin/install -c -m 644 frextract.c frextract.m frgetvect.c frgetvect.m frgetvectN.c frgetvectN.m mkframe.c mkframe.m mkframe_simevt.m '/usr/share/libframe/src/matlab'
#
