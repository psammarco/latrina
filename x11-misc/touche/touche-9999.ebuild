# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit git-r3

DESCRIPTION="The desktop application to configure Touchégg"
HOMEPAGE="https://github.com/JoseExposito/touche"

# git repo cloning properties 
EGIT_REPO_URI="https://github.com/JoseExposito/touche.git"
EGIT_CLONE_TYPE="shallow"
EGIT_COMMIT="2.0.7"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	dev-libs/gjs
	gui-libs/libadwaita
	x11-misc/touchegg
"
DEPEND="## npm needs some figure out!!
		dev-util/meson
		dev-libs/gobject-introspection
		${RDEPEND}
"

src_configure() {
	local mycmakeargs=(
	)

}

src_install() {
}
