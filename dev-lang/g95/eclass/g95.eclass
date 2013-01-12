inherit toolchain

ETYPE="gcc-compiler"

g95-compiler-configure() {
	# multilib support
	if is_multilib ; then
		confgcc="${confgcc} --enable-multilib"
	elif [[ ${CTARGET} == *-linux* ]] ; then
		confgcc="${confgcc} --disable-multilib"
	fi

	if tc_version_is_at_least "4.0" ; then
		confgcc="${confgcc} $(use_enable mudflap libmudflap)"

		if want_libssp ; then
			confgcc="${confgcc} --enable-libssp"
		else
			export gcc_cv_libc_provides_ssp=yes
			confgcc="${confgcc} --disable-libssp"
		fi
	fi

	# GTK+ is preferred over xlib in 3.4.x (xlib is unmaintained
	# right now). Much thanks to <csm@gnu.org> for the heads up.
	# Travis Tilley <lv@gentoo.org>  (11 Jul 2004)
	if ! is_gcj ; then
		confgcc="${confgcc} --disable-libgcj"
	elif use gtk ; then
		confgcc="${confgcc} --enable-java-awt=gtk"
	fi

	case $(tc-arch) in
		# Add --with-abi flags to set default MIPS ABI
		mips)
		local mips_abi=""
		use n64 && mips_abi="--with-abi=64"
		use n32 && mips_abi="--with-abi=n32"
		[[ -n ${mips_abi} ]] && confgcc="${confgcc} ${mips_abi}"
		;;
		# Enable sjlj exceptions for backward compatibility on hppa
		hppa)
			[[ ${GCC_PV:0:1} == "3" ]] && \
			confgcc="${confgcc} --enable-sjlj-exceptions"
		;;
	esac

	GCC_LANG="c"

	einfo "configuring for GCC_LANG: ${GCC_LANG}"
}

# g95_gcc_do_configure adapted from gcc_do_configure
#
# Other than the variables described for gcc_setup_variables, the following
# will alter tha behavior of gcc_do_configure:
#
#	CTARGET
#	CBUILD
#			Enable building for a target that differs from CHOST
#
#	GCC_TARGET_NO_MULTILIB
#			Disable multilib. Useful when building single library targets.
#
#	GCC_LANG
#			Enable support for ${GCC_LANG} languages. defaults to just "c"
#
# Travis Tilley <lv@gentoo.org> (04 Sep 2004)
#
g95_gcc_do_configure() {
	local confgcc

	# Set configuration based on path variables
	confgcc="${confgcc} \
		--prefix=${PREFIX} \
		--bindir=${BINPATH} \
		--includedir=${INCLUDEPATH} \
		--datadir=${DATAPATH} \
		--mandir=${DATAPATH}/man \
		--infodir=${DATAPATH}/info \
		--with-gxx-include-dir=${STDCXX_INCDIR}"

	# All our cross-compile logic goes here !  woo !
	confgcc="${confgcc} --host=${CHOST}"
	if is_crosscompile || tc-is-cross-compiler ; then
		# Straight from the GCC install doc:
		# "GCC has code to correctly determine the correct value for target
		# for nearly all native systems. Therefore, we highly recommend you
		# not provide a configure target when configuring a native compiler."
		confgcc="${confgcc} --target=${CTARGET}"
	fi
	[[ -n ${CBUILD} ]] && confgcc="${confgcc} --build=${CBUILD}"

	# ppc altivec support
	confgcc="${confgcc} $(use_enable altivec)"

	[[ ${CTARGET} == *-softfloat-* ]] && confgcc="${confgcc} --with-float=soft"

	# Native Language Support
	if use nls && ! use build ; then
		confgcc="${confgcc} --enable-nls --without-included-gettext"
	else
		confgcc="${confgcc} --disable-nls"
	fi

	# reasonably sane globals (hopefully)
	# --disable-libunwind-exceptions needed till unwind sections get fixed. see ps.m for details
	confgcc="${confgcc} \
		--with-system-zlib \
		--disable-checking \
		--disable-werror \
		--disable-libunwind-exceptions"

	# etype specific configuration
	einfo "running ${ETYPE}-configure"
	g95-compiler-configure || die

	# if not specified, assume we are building for a target that only
	# requires C support
	GCC_LANG=c
	confgcc="${confgcc} --enable-languages=${GCC_LANG}"

	if is_crosscompile ; then
		# When building a stage1 cross-compiler (just C compiler), we have to
		# disable a bunch of features or gcc goes boom
		local needed_libc=""
		case ${CTARGET} in
			*-dietlibc) needed_libc=dietlibc;;
			*-freebsd*) needed_libc=freebsd-lib;;
			*-gnu*)     needed_libc=glibc;;
			*-klibc)    needed_libc=klibc;;
			*-uclibc)   needed_libc=uclibc;;
			avr)        confgcc="${confgcc} --enable-shared --disable-threads";;
		esac
		if [[ -n ${needed_libc} ]] ; then
			if ! has_version ${CATEGORY}/${needed_libc} ; then
				confgcc="${confgcc} --disable-shared --disable-threads --without-headers"
			elif built_with_use ${CATEGORY}/${needed_libc} crosscompile_opts_headers-only ; then
				confgcc="${confgcc} --disable-shared --with-sysroot=${PREFIX}/${CTARGET}"
			else
				confgcc="${confgcc} --with-sysroot=${PREFIX}/${CTARGET}"
			fi
		fi

		if [[ ${GCCMAJOR}.${GCCMINOR} > 4.1 ]] ; then
			confgcc="${confgcc} --disable-bootstrap"
		fi
	else
		confgcc="${confgcc} --enable-shared --enable-threads=posix"

		if [[ ${GCCMAJOR}.${GCCMINOR} > 4.1 ]] ; then
			confgcc="${confgcc} --enable-bootstrap"
		fi
	fi
	# __cxa_atexit is "essential for fully standards-compliant handling of
	# destructors", but apparently requires glibc.
	# --enable-sjlj-exceptions : currently the unwind stuff seems to work
	# for statically linked apps but not dynamic
	# so use setjmp/longjmp exceptions by default
	if is_uclibc ; then
		confgcc="${confgcc} --disable-__cxa_atexit --enable-target-optspace"
		[[ ${GCCMAJOR}.${GCCMINOR} == 3.3 ]] && \
			confgcc="${confgcc} --enable-sjlj-exceptions"
	else
		confgcc="${confgcc} --enable-__cxa_atexit"
	fi
	[[ ${CTARGET} == *-gnu* ]] && confgcc="${confgcc} --enable-clocale=gnu"
	[[ ${CTARGET} == *-uclibc* ]] && [[ ${GCCMAJOR}.${GCCMINOR} > 3.3 ]] \
		&& confgcc="${confgcc} --enable-clocale=uclibc"

	# Nothing wrong with a good dose of verbosity
	echo
	einfo "PREFIX:          ${PREFIX}"
	einfo "BINPATH:         ${BINPATH}"
	einfo "LIBPATH:         ${LIBPATH}"
	einfo "DATAPATH:        ${DATAPATH}"
	einfo "STDCXX_INCDIR:   ${STDCXX_INCDIR}"
	echo
	einfo "Configuring GCC with: ${confgcc//--/\n\t--} ${@} ${EXTRA_ECONF}"
	echo

	# and now to do the actual configuration
	addwrite /dev/zero
	../configure ${confgcc} $@ ${EXTRA_ECONF} \
		|| die "failed to run configure"

}

# This function accepts one optional argument, the make target to be used.
# If ommitted, gcc_do_make will try to guess whether it should use all,
# profiledbootstrap, or bootstrap-lean depending on CTARGET and arch. An
# example of how to use this function:
#
#	gcc_do_make all-target-libstdc++-v3
#
# In addition to the target to be used, the following variables alter the
# behavior of this function:
#
#	LDFLAGS
#			Flags to pass to ld
#
#	STAGE1_CFLAGS
#			CFLAGS to use during stage1 of a gcc bootstrap
#
#	BOOT_CFLAGS
#			CFLAGS to use during stages 2+3 of a gcc bootstrap.
#
# Travis Tilley <lv@gentoo.org> (04 Sep 2004)
#
g95_gcc_do_make() {
	# Fix for libtool-portage.patch
	local OLDS=${S}
	S=${WORKDIR}/build

	# Set make target to $1 if passed
	[[ -n $1 ]] && GCC_MAKE_TARGET=$1
	# default target
	if is_crosscompile || tc-is-cross-compiler ; then
		# 3 stage bootstrapping doesnt quite work when you cant run the
		# resulting binaries natively ^^;
		GCC_MAKE_TARGET=${GCC_MAKE_TARGET-all}
	elif [[ $(tc-arch) == "x86" || $(tc-arch) == "amd64" || $(tc-arch) == "ppc64" ]] \
	 	&& [[ ${GCCMAJOR}.${GCCMINOR} > 3.3 ]]
	then
		GCC_MAKE_TARGET=${GCC_MAKE_TARGET-profiledbootstrap}
	else
		GCC_MAKE_TARGET=${GCC_MAKE_TARGET-bootstrap-lean}
	fi

	# the gcc docs state that parallel make isnt supported for the
	# profiledbootstrap target, as collisions in profile collecting may occur.
	[[ ${GCC_MAKE_TARGET} == "profiledbootstrap" ]] && export MAKEOPTS="${MAKEOPTS} -j1"

	# boundschecking seems to introduce parallel build issues
	want_boundschecking && export MAKEOPTS="${MAKEOPTS} -j1"

	if [[ ${GCC_MAKE_TARGET} == "all" ]] ; then
		STAGE1_CFLAGS=${STAGE1_CFLAGS-"${CFLAGS}"}
	elif [[ $(gcc-version) == "3.4" && ${GCC_BRANCH_VER} == "3.4" ]] && gcc-specs-ssp ; then
		# See bug #79852
		STAGE1_CFLAGS=${STAGE1_CFLAGS-"-O2"}
	else
		STAGE1_CFLAGS=${STAGE1_CFLAGS-"-O"}
	fi

	if is_crosscompile; then
		# In 3.4, BOOT_CFLAGS is never used on a crosscompile...
		# but I'll leave this in anyways as someone might have had
		# some reason for putting it in here... --eradicator
		BOOT_CFLAGS=${BOOT_CFLAGS-"-O2"}
	else
		# we only want to use the system's CFLAGS if not building a
		# cross-compiler.
		BOOT_CFLAGS=${BOOT_CFLAGS-"$(get_abi_CFLAGS) ${CFLAGS}"}
	fi

	pushd "${WORKDIR}"/build
	einfo "Running make LDFLAGS=\"${LDFLAGS}\" STAGE1_CFLAGS=\"${STAGE1_CFLAGS}\" LIBPATH=\"${LIBPATH}\" BOOT_CFLAGS=\"${BOOT_CFLAGS}\" ${GCC_MAKE_TARGET}"

	emake \
		LDFLAGS="${LDFLAGS}" \
		STAGE1_CFLAGS="${STAGE1_CFLAGS}" \
		LIBPATH="${LIBPATH}" \
		BOOT_CFLAGS="${BOOT_CFLAGS}" \
		${GCC_MAKE_TARGET} \
		|| die "emake failed with ${GCC_MAKE_TARGET}"

	if ! use build && ! is_crosscompile && ! use nocxx && use doc ; then
		if type -p doxygen > /dev/null ; then
			cd "${CTARGET}"/libstdc++-v3
			make doxygen-man || ewarn "failed to make docs"
		else
			ewarn "Skipping libstdc++ manpage generation since you don't have doxygen installed"
		fi
	fi

	popd
}

pkg_preinst() {
	einfo "Hoping that no preinst needed"
}

pkg_postinst() {
	einfo "Hoping that no postinst needed"
}

pkg_prerm() {
	einfo "Hoping that no prerm needed"
}

pkg_postrm() {
	einfo "Hoping that no postrm needed"
}

