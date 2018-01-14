# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

DESCRIPTION="a github fork of ecryptfs-simple"

HOMEPAGE="https://github.com/mhogomchungu/ecryptfs-simple"

if [[ ${PV} == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/mhogomchungu/${PN}.git"
else
	SRC_URI="https://github.com/mhogomchungu/${PN}/releases/download/${PV}/${PN}.${PV}.tar.xz"
	KEYWORDS="~amd64 ~arm ~arm64 ~x86"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE=""

DEPEND="
	virtual/pkgconfig
	dev-libs/libgcrypt
	sys-fs/ecryptfs-utils
"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${PN}.${PV}

src_configure() {
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
}
