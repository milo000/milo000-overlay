# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit git-r3

DESCRIPTION="Zyn-Fusion User Interface"
HOMEPAGE="https://github.com/mruby-zest/mruby-zest-build"
EGIT_REPO_URI="https://github.com/mruby-zest/mruby-zest-build"

LICENSE="LGPL-2.1"
SLOT="0"

DEPEND="
	dev-lang/ruby
	media-libs/mesa
"

RDEPEND="${DEPEND}"
BDEPEND="net-misc/wget"

src_prepare() {
	default
	emake -j1 setup || die "emake setup failed"
}

src_compile() {
	emake -j1 builddep || die "emake builddep failed"
	emake -j1 || die "emake failed"
}

src_install() {
	dodir "opt/zyn-fusion"
	exeinto "opt/zyn-fusion"
	doexe libzest.so
	newexe zest zyn-fusion
	dosym "/opt/zyn-fusion/zyn-fusion" "/usr/bin/zyn-fusion"
	insinto "opt/zyn-fusion"
	doins -r src/osc-bridge/schema
	dodir "opt/zyn-fusion/font"
	insinto "opt/zyn-fusion/font"
	doins deps/nanovg/example/*.ttf
	dodir "opt/zyn-fusion/qml"
	touch "${D}/opt/zyn-fusion/qml/MainWindow.qml"
}
