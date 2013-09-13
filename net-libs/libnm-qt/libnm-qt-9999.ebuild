# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit kde4-base

if [[ ${KDE_BUILD_TYPE} != live ]]; then
	KEYWORDS="~amd64"
	SRC_URI="mirror://kde/unstable/networkmanagement/${PV}/src/${P}.tar.xz"
else
	KEYWORDS=""
fi

DESCRIPTION="NetworkManager bindings for Qt"
HOMEPAGE="https://projects.kde.org/projects/extragear/libs/libnm-qt"

LICENSE="GPL-2 LGPL-2"
SLOT="4"
IUSE="debug"

DEPEND="
	net-libs/libmm-qt
	net-misc/mobile-broadband-provider-info
	>=net-misc/networkmanager-0.9.8.0
"
RDEPEND="${DEPEND}"
