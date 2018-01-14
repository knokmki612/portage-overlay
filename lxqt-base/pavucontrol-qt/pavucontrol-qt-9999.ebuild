# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

DESCRIPTION="A Pulseaudio mixer in Qt (port of pavucontrol)"

HOMEPAGE="https://github.com/lxde/pavucontrol-qt"

if [[ ${PV} == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/lxde/${PN}.git"
else
	SRC_URI="https://github.com/lxde/${PN}/releases/download/${PV}/${P}.tar.xz"
	KEYWORDS="~amd64 ~arm ~arm64 ~x86"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE=""

DEPEND="
	dev-libs/libqtxdg
	dev-qt/qtwidgets:5
	dev-qt/qtdbus:5
	dev-qt/qtsvg:5
	dev-qt/linguist-tools:5
	>=dev-util/lxqt-build-tools-0.4.0
	virtual/pkgconfig
"
RDEPEND="${DEPEND}"

src_configure() {
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
}
