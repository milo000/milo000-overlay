# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

DESCRIPTION="A command-line interface to the KDE Wallet."
HOMEPAGE="https://www.mirbsd.org/kwalletcli.htm"
SRC_URI="https://www.mirbsd.org/MirOS/dist/hosted/kwalletcli/${P}.tar.gz"

LICENSE=""
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND="
	app-shells/mksh
	kde-base/kdelibs
"
RDEPEND="${DEPEND}"

src_unpack() {
	unpack ${A}
	mv "${WORKDIR}/${PN}" "${WORKDIR}/${P}"
}

src_compile() {
	emake KDE_VER=4 LDFLAGS="-L/usr/lib/qt4"
}

src_install() {
	dodir /usr/bin
	dodir /usr/share/man/man1
	emake DESTDIR="${D}" install
}
