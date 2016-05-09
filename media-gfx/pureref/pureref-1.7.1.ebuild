# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit unpacker

DESCRIPTION="A simple and lightweight tool for artists to organize and view their reference images."
HOMEPAGE="http://www.pureref.com/"
SRC_URI="PureRef-1.7.1_x64.deb"

LICENSE="freedist no-source-code"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="bindist fetch"

RDEPEND="
	dev-libs/glib:2
	dev-libs/libbsd
	x11-libs/libX11
	x11-libs/libXau
	x11-libs/libXdmcp
	x11-libs/libXext
	x11-libs/libXi
	x11-libs/libXtst
	x11-libs/libxcb
"

S="${WORKDIR}"

pkg_nofetch() {
	einfo "Please download ${P}_x64.deb from ${HOMEPAGE} and place them in ${DISTDIR}"
}

src_unpack() {
	unpack_deb ${A}
}
src_prepare() {
	sed -i -e "/^Version=${PV}$/d" usr/share/applications/pureref.desktop || die "sed failed!"
}

src_install() {
	dobin usr/bin/PureRef
	insinto /usr
	doins -r usr/share
}
