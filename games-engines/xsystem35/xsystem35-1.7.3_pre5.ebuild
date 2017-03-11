# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit games

IUSE="alsa midi truetype joystick"

DESCRIPTION="System 3.5 for X Window System"
SRC_URI="https://launchpad.net/ubuntu/+archive/primary/+files/${PN}_1.7.3-pre5.orig.tar.gz"
HOMEPAGE="https://launchpad.net/ubuntu/+source/xsystem35/1.7.3-pre5-5"

DEPEND="=x11-libs/gtk+-2*
	media-libs/libvorbis
	sys-libs/zlib
	alsa? ( media-libs/alsa-lib media-libs/alsa-oss )
	truetype? ( media-libs/freetype )"

KEYWORDS="~x86 ~amd64"
LICENSE="GPL"
SLOT="0"

S=${WORKDIR}/${PN}-1.7.3-pre5

src_prepare() {
	epatch "${FILESDIR}/01_change_conflict_define.patch"
	epatch "${FILESDIR}/02_use_utf8.patch"
	epatch "${FILESDIR}/03_remove_libltdl.patch"
	epatch "${FILESDIR}/04_add_link_X11.patch"
}

src_compile() {
	egamesconf \
		$(use_enable joystick joy) \
		$(use_enable alsa audio alsa,oss,esd) \
		$(use_enable midi midi extp,raw,seq) \
		--enable-cdrom=linux,mp3 \
		|| die "faild configure"

	make || die "faild emake"
}

src_install() {
	emake DESTDIR=\"\${D}\" install || die
	into ${GAMES_PREFIX}
	dobin ${FILESDIR}/xsystem35-install
	insinto ${GAMES_DATADIR}/${PN}
	doins ${S}/contrib/* ${S}/src/xsys35rc.sample
	exeinto ${GAMES_DATADIR}/${PN}
	doexe ${S}/contrib/instgame

	dodoc COPYING INSTALL doc/README* doc/FAQ doc/GAMES.TXT \
			doc/GRFMT.TXT doc/MISCGAME.TXT doc/BUGS contrib/README.TXT

	prepgamesdirs
}

pkg_postinst() {
	einfo ""
	einfo "you need GAME DISC maid by ALICE SOFT"
	einfo "mount GAME DISC and type command"
	einfo "\$ system35-install HOGE.inf"
	einfo "'HOGE.inf' in ${GAMES_DATADIR}/${PN}/, you can choose suitable file"
	einfo "after installed game data, you type"
	einfo "\$ system35 -gamefile ~/game/HOGE.gr"
	einfo ""
}
