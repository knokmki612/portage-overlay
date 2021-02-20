# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit git-r3 cmake-utils

DESCRIPTION="An open Apple Wireless Direct Link (AWDL) implementation written in C"
HOMEPAGE="https://owlink.org/"
EGIT_REPO_URI="git://github.com/seemoo-lab/owl.git"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

src_configure() {
  cmake-utils_src_configure
}
