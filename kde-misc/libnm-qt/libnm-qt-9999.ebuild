# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

KDE_MINIMAL="4.6"

inherit kde4-base

DESCRIPTION="NM bindings for QT"
HOMEPAGE="http://kde.org/"

LICENSE="GPL-2 LGPL-2"
KEYWORDS=""
SLOT="4"
IUSE=""

DEPEND="
	kde-misc/libmm-qt
	net-misc/mobile-broadband-provider-info
	>=net-misc/networkmanager-0.9.0
"
RDEPEND="${DEPEND}"
