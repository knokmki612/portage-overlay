# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Additional support for proprietary codecs for vivaldi"
HOMEPAGE="https://aur.archlinux.org/packages/vivaldi-ffmpeg-codecs/"
SRC_URI="https://repo.herecura.eu/herecura/x86_64/${PN}-${PV/_p1/-1}-x86_64.pkg.tar.xz"

LICENSE="LGPL2.1"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="www-client/vivaldi"

S=${WORKDIR}

src_unpack() {
	unpack ${A}
}

src_install() {
	mv * "${D}" || die
}
