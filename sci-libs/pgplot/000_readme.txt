In pgplot-5.2.2-r99.ebuild, you can uncomment different lines for the drivers patch:
   
  epatch "${FILESDIR}"/${PN}-drivers.patch
  #epatch "${FILESDIR}"/${PN}-drivers-nox.patch
  #epatch "${FILESDIR}"/${PN}-drivers-ppmonly.patch
  
  the -nox has no support for X (and doesn't need libX11 and other libraries when linking statically)
  the -ppmonly has support for .ppm files only, and is only slightly smaller than -nox
  
  use /root/drivers.list.orig to make additional patches.
  
