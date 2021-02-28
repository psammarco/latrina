# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit linux-info linux-mod git-r3

DESCRIPTION="r8814 driver for Realtek 8814au wireless NICs"
HOMEPAGE="https://github.com/aircrack-ng/rtl8814au"
EGIT_REPO_URI="https://github.com/aircrack-ng/rtl8814au.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

MODULE_NAMES="8814au(net/wireless)"
BUILD_TARGETS="modules"

CONFIG_CHECK="USB CFG80211 REALTEK_PHY"

pkg_setup() {
	linux-mod_pkg_setup
	BUILD_PARAMS="-C ${KV_DIR} M=${S} CONFIG_RTL8814AU=m"
}

src_install() {
	linux-mod_src_install
	einstalldocs
}
