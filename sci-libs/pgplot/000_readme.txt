* In pgplot-5.2.2-r99.ebuild, you can uncomment different lines for the drivers patch:
   
  epatch "${FILESDIR}"/${PN}-drivers.patch
  #epatch "${FILESDIR}"/${PN}-drivers-nox.patch
  #epatch "${FILESDIR}"/${PN}-drivers-ppmonly.patch
  
  the -nox has no support for X (and doesn't need libX11 and other libraries when linking statically)
  the -ppmonly has support for .ppm files only, and is only slightly smaller than -nox
  
  use /root/drivers.list.orig to make additional patches.

* PPM-only for Think
1) set ebuild to -ppmonly
2) USE=-doc ebuild pgplot-5.2.2-r99.ebuild clean manifest install
3) cp ~/usr/lib/libpgplot-ppmonly.a ~/usr/lib/old/
4) cp /var/tmp/portage/portage/sci-libs/pgplot-5.2.2-r99/image/usr/lib64/libpgplot.a ~/usr/lib/libpgplot-ppmonly.a

* PPM-only for For zotac (?)
1) set ebuild to -ppmonly
2) USE=-doc ebuild pgplot-5.2.2-r99.ebuild clean manifest install
3) rsync /var/tmp/portage/portage/sci-libs/pgplot-5.2.2-r99/image/usr/lib64/libpgplot.a zotac:usr/lib/libpgplot-ppmonly.a

