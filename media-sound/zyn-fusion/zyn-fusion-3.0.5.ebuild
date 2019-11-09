# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7
USE_RUBY="ruby26"

inherit git-r3 ruby-single

DESCRIPTION="Zyn-Fusion User Interface"
HOMEPAGE="https://github.com/mruby-zest/mruby-zest-build"
EGIT_REPO_URI="https://github.com/mruby-zest/mruby-zest-build"
EGIT_COMMIT="${PV}"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	${RUBY_DEPS}
	media-libs/mesa
"

RDEPEND="${DEPEND}"

pkg_pretend() {
	if has network-sandbox ${FEATURES}; then
		die "Requires FEATURES=-network-sandbox"
	fi
}

src_prepare() {
	default
	emake setup || die "emake setup failed"
}

src_compile() {
	emake builddep || die "emake builddep failed"
	emake || die "emake failed"
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
