# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python3_{4,5,6} )

inherit eutils distutils-r1 python-r1

DESCRIPTION="A graphical journal with calendar, templates, tags, keyword searching, and export functionality"
HOMEPAGE="http://rednotebook.sourceforge.net"
SRC_URI="https://github.com/jendrikseipp/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="spell"

RDEPEND="
	dev-python/pyyaml[${PYTHON_USEDEP}]
	>=net-libs/webkit-gtk-2.16
	>=x11-libs/gtk+-3.10
	spell? ( dev-python/pyenchant[${PYTHON_USEDEP}] )"
DEPEND="${RDEPEND}"

