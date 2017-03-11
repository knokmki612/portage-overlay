# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

# based on xorg-2.eclass

EAPI=5

DESCRIPTION="X.Org twm application include ohki patch"

KEYWORDS=""
IUSE=""

RDEPEND="!x11-wm/twm
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXt
	x11-libs/libXmu
	x11-libs/libICE
	x11-libs/libSM
	x11-libs/libXrandr"
DEPEND="${RDEPEND}
	sys-devel/bison"

GIT_ECLASS=""
if [[ ${PV} == *9999* ]]; then
	GIT_ECLASS="git-r3"
	XORG_EAUTORECONF="yes"
fi

# we need to inherit autotools first to get the deps
inherit autotools autotools-utils eutils libtool multilib toolchain-funcs \
	flag-o-matic ${FONT_ECLASS} ${GIT_ECLASS}

IUSE=""
HOMEPAGE="https://github.com/knokmki612/twm-ohki"

if [[ -n ${GIT_ECLASS} ]]; then
	: ${EGIT_REPO_URI:="https://github.com/knokmki612/twm-ohki.git"}
else
	SRC_URI="https://github.com/knokmki612/twm-ohki/releases/download/twm-ohki-${PV}/twm-ohki-${PV}.tar.gz"
fi

: ${SLOT:=0}

# Set the license for the package. This can be overridden by setting
# LICENSE after the inherit. Nearly all FreeDesktop-hosted X packages
# are under the MIT license. (This is what Red Hat does in their rpms)
: ${LICENSE:=MIT}

# Set up autotools shared dependencies
# Remember that all versions here MUST be stable
XORG_EAUTORECONF_ARCHES="x86-interix ppc-aix x86-winnt"
EAUTORECONF_DEPEND+="
	>=sys-devel/libtool-2.2.6a
	sys-devel/m4"
if [[ ${PN} != util-macros ]] ; then
	EAUTORECONF_DEPEND+=" >=x11-misc/util-macros-1.18"
fi
WANT_AUTOCONF="latest"
WANT_AUTOMAKE="latest"
for arch in ${XORG_EAUTORECONF_ARCHES}; do
	EAUTORECONF_DEPENDS+=" ${arch}? ( ${EAUTORECONF_DEPEND} )"
done
DEPEND+=" ${EAUTORECONF_DEPENDS}"
[[ ${XORG_EAUTORECONF} != no ]] && DEPEND+=" ${EAUTORECONF_DEPEND}"
unset EAUTORECONF_DEPENDS
unset EAUTORECONF_DEPEND

DEPEND+=" virtual/pkgconfig"

debug-print "${LINENO} ${ECLASS} ${FUNCNAME}: DEPEND=${DEPEND}"
debug-print "${LINENO} ${ECLASS} ${FUNCNAME}: RDEPEND=${RDEPEND}"
debug-print "${LINENO} ${ECLASS} ${FUNCNAME}: PDEPEND=${PDEPEND}"

# Simply unpack source code.
src_unpack() {
	debug-print-function ${FUNCNAME} "$@"

	if [[ -n ${GIT_ECLASS} ]]; then
		git-r3_src_unpack
	else
		unpack ${A}
	fi
}

# @FUNCTION: xorg-2_patch_source
# @DESCRIPTION:
# Apply all patches
xorg-2_patch_source() {
	debug-print-function ${FUNCNAME} "$@"

	# Use standardized names and locations with bulk patching
	# Patch directory is ${WORKDIR}/patch
	# See epatch() in eutils.eclass for more documentation
	EPATCH_SUFFIX=${EPATCH_SUFFIX:=patch}

	[[ -d "${EPATCH_SOURCE}" ]] && epatch
}

# @FUNCTION: xorg-2_reconf_source
# @DESCRIPTION:
# Run eautoreconf if necessary, and run elibtoolize.
xorg-2_reconf_source() {
	debug-print-function ${FUNCNAME} "$@"

	case ${CHOST} in
		*-interix* | *-aix* | *-winnt*)
			# some hosts need full eautoreconf
			[[ -e "./configure.ac" || -e "./configure.in" ]] \
				&& AUTOTOOLS_AUTORECONF=1
			;;
		*)
			# elibtoolize required for BSD
			[[ ${XORG_EAUTORECONF} != no && ( -e "./configure.ac" || -e "./configure.in" ) ]] \
				&& AUTOTOOLS_AUTORECONF=1
			;;
	esac
}

# Prepare a package after unpacking, performing all X-related tasks.
src_prepare() {
	debug-print-function ${FUNCNAME} "$@"

	xorg-2_patch_source
	xorg-2_reconf_source
	autotools-utils_src_prepare "$@"
}

# @FUNCTION: xorg-2_flags_setup
# @DESCRIPTION:
# Set up CFLAGS for a debug build
xorg-2_flags_setup() {
	debug-print-function ${FUNCNAME} "$@"

	# Win32 require special define
	[[ ${CHOST} == *-winnt* ]] && append-cppflags -DWIN32 -D__STDC__
	# hardened ldflags
	[[ ${PN} = xorg-server || -n ${DRIVER} ]] && append-ldflags -Wl,-z,lazy

	# Quite few libraries fail on runtime without these:
	if has static-libs ${IUSE//+}; then
		filter-flags -Wl,-Bdirect
		filter-ldflags -Bdirect
		filter-ldflags -Wl,-Bdirect
	fi
}

# Perform any necessary pre-configuration steps, then run configure
src_configure() {
	debug-print-function ${FUNCNAME} "$@"

	xorg-2_flags_setup

	# Check if package supports disabling of dep tracking
	# Fixes warnings like:
	#    WARNING: unrecognized options: --disable-dependency-tracking
	if grep -q -s "disable-depencency-tracking" ${ECONF_SOURCE:-.}/configure; then
		local dep_track="--disable-dependency-tracking"
	fi

	local myeconfargs=(
		${dep_track}
	)

	autotools-utils_src_configure "$@"
}

# Compile a package, performing all X-related tasks.
src_compile() {
	debug-print-function ${FUNCNAME} "$@"

	autotools-utils_src_compile "$@"
}

# Install a built package to ${D}, performing any necessary steps.
# Creates a ChangeLog from git if using live ebuilds.
src_install() {
	debug-print-function ${FUNCNAME} "$@"

	local install_args=( docdir="${EPREFIX}/usr/share/doc/${PF}" )

	autotools-utils_src_install "${install_args[@]}"

	if [[ -n ${GIT_ECLASS} ]]; then
		pushd "${EGIT_STORE_DIR}/${EGIT_CLONE_DIR}" > /dev/null || die
		git log ${EGIT_COMMIT} > "${S}"/ChangeLog
		popd > /dev/null || die
	fi

	if [[ -e "${S}"/ChangeLog ]]; then
		dodoc "${S}"/ChangeLog || die "dodoc failed"
	fi

	# Don't install libtool archives (even for modules)
	prune_libtool_files --all
}
