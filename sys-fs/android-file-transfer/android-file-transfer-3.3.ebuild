# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

DESCRIPTION="Reliable MTP client with minimalistic UI"
HOMEPAGE="http://whoozle.github.io/android-file-transfer-linux/"
SRC_URI="https://github.com/whoozle/android-file-transfer-linux/archive/v${PV}.tar.gz"
S="${WORKDIR}/${PN}-linux-${PV}"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	sys-fs/fuse
	dev-qt/qtwidgets"
DEPEND="${RDEPEND}
	dev-util/cmake"

src_configure() {
	local mycmakeargs=(
			-DBUILD_SHARED_LIB=ON
	)
	
	cmake-utils_src_configure
}
