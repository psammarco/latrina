# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit eutils java-vm-2 prefix versionator

DESCRIPTION="Oracle's Java JDK 15"
HOMEPAGE="https://www.oracle.com/java/technologies/javase/15-relnote-issues.html"


LICENSE="Oracle-BCLA-JavaSE"
SLOT="15"
KEYWORDS="~amd64"
IUSE="alsa cups +fontconfig headless-awt nsplugin pax_kernel selinux"

RESTRICT="preserve-libs strip"
QA_PREBUILT="*"

JDK_SRC="https://downloads.sourceforge.net/project/oracle-jdk-15-bin-gentoo/${P}_linux-x64.tar.gz -> jdk-${SLOT}_linux-x64_bin.tar.gz"

SRC_URI="
amd64? ( ${JDK_SRC} )"

RDEPEND="!x64-macos? (
		!headless-awt? (
			x11-libs/libX11
			x11-libs/libXext
			x11-libs/libXi
			x11-libs/libXrender
			x11-libs/libXtst
		)
	)
	alsa? ( media-libs/alsa-lib )
	cups? ( net-print/cups )
	fontconfig? ( media-libs/fontconfig:1.0 )
	!prefix? ( sys-libs/glibc:* )
	selinux? ( sec-policy/selinux-java )"

# A PaX header isn't created by scanelf so depend on paxctl to avoid
# fallback marking. See bug #427642.
DEPEND="app-arch/zip
	pax_kernel? ( sys-apps/paxctl )"

S="${WORKDIR}/jdk"

src_unpack() {
	default

	mv "${WORKDIR}"/jdk* "${S}" || die 
}

src_install() {
	local dest="/opt/${P}"
	local ddest="${ED}${dest#/}"

	# Create files used as storage for system preferences.
	mkdir .systemPrefs || die
	touch .systemPrefs/.system.lock || die
	touch .systemPrefs/.systemRootModFile || die

	if use headless-awt ; then
		rm -vf lib/*/lib*{[jx]awt,splashscreen}* \
		   bin/{javaws,policytool} || die
	fi

	dodir "${dest}"
	cp -pPR	bin lib man "${ddest}" || die

	if use nsplugin ; then
		local nsplugin_link=${nsplugin##*/}
		nsplugin_link=${nsplugin_link/./-${PN}-${SLOT}.}
		dosym "${dest}/${nsplugin}" "/usr/$(get_libdir)/nsbrowser/plugins/${nsplugin_link}"
	fi

	# Set PaX markings on all JDK/JRE executables to allow code-generation on the heap by the JIT compiler.
	# The markings need to be set prior to the first invocation of the the freshly built / installed VM. Be it before creating the Class Data Sharing archive or generating cacerts. 
	# Otherwise a PaX enabled kernel will kill the VM. Bug #215225 #389751
	java-vm_set-pax-markings "${ddest}"

	# Remove empty dirs we might have copied.
	find "${D}" -type d -empty -exec rmdir -v {} + || die

	set_java_env
	java-vm_revdep-mask
	#java-vm_sandbox-predict /dev/random /proc/self/coredump_filter
}

pkg_postinst() {
    elog "Upon installation completed, please enable Java on your system by running:"
	elog "sudo eselect java-vm set system oracle-jdk-bin-15"
	elog "eselect java-vm set user oracle-jdk-bin-15"
}
