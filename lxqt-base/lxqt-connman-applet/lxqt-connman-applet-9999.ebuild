# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

DESCRIPTION="System-tray applet for connman made by LXQt project"

HOMEPAGE="https://github.com/lxde/lxqt-connman-applet"

if [[ ${PV} == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/lxde/${PN}.git"
else
	SRC_URI="https://github.com/lxde/lxqt-connman-applet/releases/download/${P}.tar.gz"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
fi

LICENSE="LGPL-2.1+"
SLOT="0"
IUSE=""

DEPEND="
	dev-libs/libqtxdg
	dev-qt/qtwidgets:5
	dev-qt/qtdbus:5
	dev-qt/qtsvg:5
	dev-qt/linguist-tools:5
"
RDEPEND="${DEPEND}"

src_configure() {
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
}
