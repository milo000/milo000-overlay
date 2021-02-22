# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=7
inherit cmake-utils desktop toolchain-funcs xdg-utils

DESCRIPTION="Animated sprite editor & pixel art tool"
HOMEPAGE="https://www.aseprite.org"
LICENSE="Proprietary"
SLOT="0"

PATCHES=( "${FILESDIR}/${P}-system_libarchive.patch"
	"${FILESDIR}/${P}-system_libwebp.patch"
	"${FILESDIR}/FindWebP.cmake.patch" )

SRC_URI="https://github.com/${PN}/${PN}/releases/download/v${PV//_/-}/${PN^}-v${PV//_/-}-Source.zip"
KEYWORDS="~amd64 ~x86"
S="${WORKDIR}"

IUSE="
	debug
	kde
	memleak
	webp"

RDEPEND="
	app-arch/libarchive
	app-text/cmark
	dev-libs/expat
	dev-libs/tinyxml
	=media-gfx/aseprite-skia-9999-r81[debug=]
	media-libs/freetype:2
	>=media-libs/giflib-5.0
	media-libs/fontconfig
	media-libs/libpng:0
	webp? ( media-libs/libwebp )
	net-misc/curl
	sys-apps/util-linux
	sys-libs/zlib
	virtual/jpeg:=
	x11-libs/libX11
	x11-libs/pixman
	kde? (
		dev-qt/qtcore:5
		kde-frameworks/kio:5 )"
DEPEND="$RDEPEND
	app-arch/unzip"

DOCS=( EULA.txt
	docs/ase-file-specs.md
	docs/LICENSES.md
	README.md )

src_prepare() {
	cmake-utils_src_prepare
}

src_configure() {
	use debug && CMAKE_BUILD_TYPE=Debug || CMAKE_BUILD_TYPE=Release

	local mycmakeargs=(
		-DENABLE_UPDATER=OFF
		-DFULLSCREEN_PLATFORM=ON
		-DUSE_SHARED_CMARK=ON
		-DUSE_SHARED_CURL=ON
		-DUSE_SHARED_GIFLIB=ON
		-DUSE_SHARED_JPEGLIB=ON
		-DUSE_SHARED_ZLIB=ON
		-DUSE_SHARED_LIBARCHIVE=ON
		-DUSE_SHARED_LIBPNG=ON
		-DUSE_SHARED_LIBWEBP=ON
		-DUSE_SHARED_TINYXML=ON
		-DUSE_SHARED_PIXMAN=ON
		-DUSE_SHARED_FREETYPE=ON
		-DUSE_SHARED_HARFBUZZ=ON
		-DWITH_DESKTOP_INTEGRATION=ON
		-DWITH_QT_THUMBNAILER="$(usex kde)"
		-DWITH_WEBP_SUPPORT="$(usex webp)"
		-DENABLE_MEMLEAK="$(usex memleak)"
		-DSKIA_DIR="/usr/lib/aseprite-skia"
		-DSKIA_LIBRARY="/usr/lib/aseprite-skia/out/Release/libskia.a"
		-DSKSHAPER_LIBRARY="/usr/lib/aseprite-skia/out/Release/libskshaper.a"
	)

	cmake-utils_src_configure
}

src_install() {
	iconsize=(16 32 48 64 128 256)
	for size in "${iconsize[@]}"; do
		newicon -s $size "${S}/data/icons/ase${size}.png" "${PN}.png"
	done
	cmake-utils_src_install
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
	elog "Aseprite is for personal use only. You may not distribute it."
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
}
