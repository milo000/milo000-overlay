# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

## TODO
# add sound support (no sound files)

EAPI=5
VIRTUALX_REQUIRED="manual"
inherit eutils gnome2-utils toolchain-funcs games git-r3

DESCRIPTION="Dungeon Crawl Stone Soup is a role-playing roguelike game of exploration and treasure-hunting in dungeons"
HOMEPAGE="http://crawl.develz.org/wordpress/"
SRC_URI="https://dev.gentoo.org/~hasufell/distfiles/${PN}.png
	https://dev.gentoo.org/~hasufell/distfiles/${PN}.svg"

EGIT_REPO_URI="https://github.com/crawl/crawl"
EGIT_SUBMODULES=()

# 3-clause BSD: mt19937ar.cc, MSVC/stdint.h
# 2-clause BSD: all contributions by Steve Noonan and Jesse Luehrs
# Public Domain|CC0: most of tiles
# MIT: json.cc/json.h, some .js files in webserver/static/scripts/contrib/
LICENSE="GPL-2 BSD BSD-2 public-domain CC0-1.0 MIT"
SLOT="0"
IUSE="debug luajit ncurses test +tiles"
# test is broken
# see https://crawl.develz.org/mantis/view.php?id=6121
RESTRICT="test"

RDEPEND="
	dev-db/sqlite:3
	luajit? ( >=dev-lang/luajit-2.0.0 )
	!luajit? ( dev-lang/lua:= )
	sys-libs/zlib
	!ncurses? ( !tiles? ( sys-libs/ncurses ) )
	ncurses? ( sys-libs/ncurses )
	tiles? (
		media-fonts/dejavu
		media-libs/freetype:2
		media-libs/libpng:0
		media-libs/libsdl2[opengl,video]
		media-libs/sdl2-image[png]
		virtual/glu
		virtual/opengl
	)"
DEPEND="${RDEPEND}
	dev-lang/perl
	sys-devel/flex
	virtual/pkgconfig
	virtual/yacc
	tiles? (
		sys-libs/ncurses
	)"

S="${WORKDIR}/${P}/crawl-ref/source"
S_TEST="${WORKDIR}/${P}_test/crawl-ref/source"

pkg_setup() {
	games_pkg_setup
	if use !ncurses && use !tiles ; then
		ewarn "Neither ncurses nor tiles frontend"
		ewarn "selected, choosing ncurses only."
		ewarn "Note that you can also enable both."
	fi
}

src_prepare() {
	epatch "${FILESDIR}"/${P}-respect-flags-and-compiler.patch
}

src_compile() {
	export HOSTCXX=$(tc-getBUILD_CXX)

	# leave DATADIR at the top
	myemakeargs=(
		USE_LUAJIT=$(usex luajit "yes" "")
		DATADIR="${GAMES_DATADIR}/${PN}"
		V=1
		prefix="${GAMES_PREFIX}"
		SAVEDIR="~/.crawl"
		$(usex debug "FULLDEBUG=y DEBUG=y" "")
		CFOPTIMIZE="${CXXFLAGS}"
		LDFLAGS="${LDFLAGS}"
		MAKEOPTS="${MAKEOPTS}"
		AR="$(tc-getAR)"
		RANLIB="$(tc-getRANLIB)"
		CC="$(tc-getCC)"
		CXX="$(tc-getCXX)"
		PKGCONFIG="$(tc-getPKG_CONFIG)"
		STRIP=touch
	)

	if use ncurses || (use !ncurses && use !tiles) ; then
		emake "${myemakeargs[@]}"
		# move it in case we build both variants
		use tiles && { mv crawl "${WORKDIR}"/crawl-ncurses || die ;}
	fi

	if use tiles ; then
		emake clean
		emake "${myemakeargs[@]}" "TILES=y"
	fi
}

src_install() {
	emake "${myemakeargs[@]}" $(usex tiles "TILES=y" "") DESTDIR="${D}" prefix_fp="" bin_prefix="${D}${GAMES_BINDIR}" install
	[[ -e "${WORKDIR}"/crawl-ncurses ]] && dogamesbin "${WORKDIR}"/crawl-ncurses

	# don't relocate docs, needed at runtime
	rm -rf "${D}${GAMES_DATADIR}"/${PN}/docs/license
	# missing in 0.17.0+
	#dodoc "${WORKDIR}"/${MY_P}/README.{txt,pdf}

	# icons and menu for graphical build
	if use tiles ; then
		doicon -s 48 "${DISTDIR}"/${PN}.png
		doicon -s scalable "${DISTDIR}"/${PN}.svg
		make_desktop_entry crawl
	fi

	prepgamesdirs
}

pkg_preinst() {
	games_pkg_preinst
	gnome2_icon_savelist
}

pkg_postinst() {
	games_pkg_postinst
	gnome2_icon_cache_update

	if use tiles && use ncurses ; then
		elog "Since you have enabled both tiles and ncurses frontends"
		elog "the ncurses binary is called 'crawl-ncurses' and the"
		elog "tiles binary is called 'crawl'."
	fi
}

pkg_postrm() {
	gnome2_icon_cache_update
}
