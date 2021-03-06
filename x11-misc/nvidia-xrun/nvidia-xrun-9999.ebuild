# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=7

inherit eutils git-r3

DESCRIPTION="Script to run dedicated X server with discrete nvidia graphics"
HOMEPAGE="https://github.com/Witko/nvidia-xrun"
EGIT_REPO_URI="https://github.com/Witko/nvidia-xrun.git"
EGIT_COMMIT="97febf413d5fa9a7519e0edb63b9ba3e0ec20cd6"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="
	media-libs/mesa
	sys-power/bbswitch
	x11-apps/xinit
	x11-base/xorg-server[xorg]
	x11-drivers/nvidia-drivers[X,driver]
	x11-libs/libXrandr
"

src_prepare() {
	default
	sed -in -e "/\/nvidia\/xorg/d" -e "" -e "s/\/nvidia/\/opengl\/nvidia/g" nvidia-xorg.conf
	sed -in -e "s/lib64\/nvidia/lib64\/opengl\/nvidia\/lib/g" -e "s/lib32\/nvidia/lib32\/opengl\/nvidia\/lib/g" nvidia-xinitrc
}

src_install() {
	dobin nvidia-xrun
	insinto /etc/X11
	doins nvidia-xorg.conf
	insinto /etc/X11/xinit
	doins nvidia-xinitrc
	dodir /etc/X11/xinit/nvidia-xinitrc.d
}
