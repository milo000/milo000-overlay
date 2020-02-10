# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=7
inherit unpacker xdg-utils

DESCRIPTION="A simple and lightweight tool for artists to organize and view their reference images."
HOMEPAGE="http://www.pureref.com/"
SRC_URI="PureRef-${PV}_x64.deb"

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

QA_PRESTRIPPED="usr/bin/PureRef"
QA_PREBUILT="usr/bin/PureRef"

S="${WORKDIR}"

pkg_nofetch() {
	einfo "Please download PureRef-${PV}_x64.deb from ${HOMEPAGE}download.php and place it in ${DISTDIR}"
}

src_unpack() {
	unpack_deb ${A}
}

src_prepare() {
	mv usr/share/doc/pureref usr/share/doc/pureref-${PV}
	sed -i -e "/^Version=${PV}$/d" usr/share/applications/pureref.desktop || die "sed failed!"

	default
}

src_install() {
	dobin usr/bin/PureRef
	insinto /usr
	doins -r usr/share
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
}
