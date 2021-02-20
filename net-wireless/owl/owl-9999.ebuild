# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CMAKE_ECLASS="cmake"
inherit git-r3 cmake-multilib

DESCRIPTION="An open Apple Wireless Direct Link (AWDL) implementation written in C"
HOMEPAGE="https://owlink.org/"

EGIT_REPO_URI="https://github.com/seemoo-lab/owl.git"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64"
IUSE=""

BDEPEND="net-libs/libpcap dev-libs/libev dev-libs/libnl:3"

PATCHES=( "${FILESDIR}/install-shared-libraries.patch" )
