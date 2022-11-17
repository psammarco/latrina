# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit cmake git-r3

DESCRIPTION="Linux multitouch gesture recognizer"
HOMEPAGE="https://github.com/JoseExposito/touchegg"

# git repo cloning properties 
EGIT_REPO_URI="https://github.com/JoseExposito/touchegg.git"
EGIT_CLONE_TYPE="shallow"
EGIT_COMMIT="2.0.14"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gtk"

CONFIG_CHECK="INPUT_EVDEV"

RDEPEND="
	dev-util/cmake
	dev-libs/libinput
	dev-libs/pugixml
	x11-libs/cairo
	x11-libs/libX11
	x11-libs/libXtst
	x11-libs/libXrandr
	x11-libs/libXi
	dev-libs/glib:2
	x11-libs/gtk+:3
	virtual/libudev
"
DEPEND="${RDEPEND}"

src_configure() {
	local mycmakeargs=(
		-DAUTO_COLORS="$(usex gtk)"
		# upstream doesn't like linking against libsystemd
		-DUSE_SYSTEMD="OFF"
	)

	cmake_src_configure
}

src_install() {
	cmake_src_install
	doinitd "${FILESDIR}"/"${PN}"
	systemd_dounit "${FILESDIR}"/"${PN}".service
}
