# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="Another free touch typing tutor program"
HOMEPAGE="http://klavaro.sourceforge.net/"
SRC_URI="mirror://sourceforge/project/${PN}/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"

BDEPEND="
	dev-util/intltool
	>=sys-devel/gettext-0.18.3
"
RDEPEND="
	net-misc/curl
	x11-libs/cairo
	x11-libs/gtk+:3
	x11-libs/gtkdatabox
	x11-libs/pango
"

DEPEND="${RDEPEND}"

src_prepare() {
	default

	eautoreconf
}
