# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit rpm

MY_P=${P/-bin/}
S="${WORKDIR}"

DESCRIPTION="Digital Mars D Compiler"
HOMEPAGE="http://dlang.org"
SRC_URI="
  x86?	  ( http://ftp.digitalmars.com/${MY_P}-0.fedora.i386.rpm )
  amd64?  ( http://ftp.digitalmars.com/${MY_P}-0.fedora.x86_64.rpm )"

LICENSE="Artistic Boost-1.0 GPL-1+"
SLOT="0"
KEYWORDS="x86 amd64"

DEPEND=""
RDEPEND="${DEPEND}"

src_unpack() {
	rpm_src_unpack ${A}
}

src_install() {
	use amd64 && mv "${S}/usr/lib" "${S}/usr/lib32"
	cp -R "${S}/etc" "${D}/" || die "Install failed!"
	cp -R "${S}/usr" "${D}/" || die "Install failed!"
}
