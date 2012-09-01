# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
inherit git-2 systemd

DESCRIPTION="Symlinks and syncs browser profile dirs to RAM"
HOMEPAGE="https://github.com/graysky2/profile-sync-daemon"
EGIT_REPO_URI="git://github.com/graysky2/${PN}.git"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

src_install() {
	dobin "${PN}"

	insinto /etc
	doins psd.conf
	doinitd "${FILESDIR}"/psd

	exeinto /etc/cron.hourly
	newexe psd.cron.hourly psd-update

	systemd_dounit psd.service

	newman psd.manpage psd.8
}
