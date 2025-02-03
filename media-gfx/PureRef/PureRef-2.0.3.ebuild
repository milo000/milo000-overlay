# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop

DESCRIPTION="PureRef - Reference Image Viewer"
HOMEPAGE="https://www.pureref.com"
SRC_URI="${P}_x64.deb"
RESTRICT="fetch strip"
LICENSE=""
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND="sys-fs/fuse:0"

S="${WORKDIR}"

pkg_nofetch() {
	einfo "Please download ${P}_x64.deb and move it to"
	einfo "your distfiles directory:"
	einfo "https://www.pureref.com/download.php"
	einfo
}

src_unpack() {
	unpack ${A}
	unpack ./data.tar.xz
}

src_install() {
	local s
	exeinto /usr/bin
	doexe ${S}/usr/bin/PureRef
	domenu ${S}/usr/share/applications/pureref.desktop

	for s in 16 32 48 64 128 256 ; do
		doicon -s ${s} ${S}/usr/share/icons/hicolor/${s}x${s}/apps/pureref.png
		doicon -c mimetypes -s ${s} ${S}/usr/share/icons/hicolor/${s}x${s}/mimetypes/application-pureref.png
	done
	doicon -s scalable ${S}/usr/share/icons/hicolor/scalable/apps/pureref.svg
	doicon -c mimetypes -s scalable ${S}/usr/share/icons/hicolor/scalable/mimetypes/application-pureref.svg

	insinto /usr/share/mime/packages
	doins ${S}/usr/share/mime/packages/pureref.xml
}
