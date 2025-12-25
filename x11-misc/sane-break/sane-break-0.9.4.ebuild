# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake xdg

DESCRIPTION="Cross-platform break reminder application"
HOMEPAGE="https://github.com/AllanChain/sane-break"
SRC_URI="https://github.com/AllanChain/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="wayland X"

DEPEND="
	dev-qt/qtbase:6[dbus,gui,widgets,wayland?]
	dev-qt/qtmultimedia:6
	wayland? ( kde-plasma/layer-shell-qt )
	X? ( x11-libs/libXScrnSaver )
"
RDEPEND="${DEPEND}"
