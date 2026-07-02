# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# To generate the Go deps tarball for a new version:
#   extract tarball
#   GOMODCACHE="${PWD}"/go-mod go mod download -modcacherw -x
#   tar --create --auto-compress --file nordvpn-${PV}-deps.tar.xz go-mod

EAPI=8

inherit desktop go-module systemd tmpfiles xdg-utils

MY_PN="nordvpn-linux"
DESCRIPTION="NordVPN native Linux client"
HOMEPAGE="https://nordvpn.com https://github.com/NordSecurity/nordvpn-linux"
SRC_URI="
	https://github.com/NordSecurity/${MY_PN}/archive/${PV}.tar.gz -> ${P}.tar.gz
	https://cafarelli.fr/gentoo/${P}-deps.tar.xz
"

S="${WORKDIR}/${MY_PN}-${PV}"

# GPL-3 for nordvpn itself, bundled Go deps have various licenses
LICENSE="GPL-3"
LICENSE+=" Apache-2.0 BSD BSD-2 ISC MIT MPL-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
IUSE="meshnet"
RESTRICT="test"

RDEPEND="
	acct-group/nordvpn
	app-misc/ca-certificates
	dev-libs/libxml2
	net-firewall/nftables
	sys-apps/iproute2
"
DEPEND="${RDEPEND}"
BDEPEND=">=dev-lang/go-1.25.3"

src_compile() {
	local go_ldflags=(
		-X "'main.Version=${PV}'"
		-X "'main.Environment=prod'"
		-X "'main.Hash=${PV}'"
		-X "'main.Salt=f1nd1ngn3m0'"
	)

	# Building without telio/drop tags produces a FOSS-only build
	# that uses kernel WireGuard instead of NordSecurity's libtelio.
	# TODO look into libtelio packaging
	local go_tags=""

	local programs="cli daemon norduser"
	use meshnet && programs+=" fileshare"

	for program in ${programs}; do
		local binname
		case ${program} in
			cli) binname=nordvpn ;;
			daemon) binname=nordvpnd ;;
			fileshare) binname=nordfileshare ;;
			norduser) binname=norduserd ;;
		esac

		einfo "Building ${binname}..."
		ego build \
			${go_tags:+-tags "${go_tags}"} \
			-ldflags "-linkmode=external ${go_ldflags[*]}" \
			-o "bin/${binname}" \
			"./cmd/${program}"
	done
}

src_install() {
	dobin bin/nordvpn
	dosbin bin/nordvpnd

	exeinto /usr/lib/nordvpn
	doexe bin/norduserd
	fowners root:nordvpn /usr/lib/nordvpn/norduserd
	fperms 0550 /usr/lib/nordvpn/norduserd

	if use meshnet; then
		doexe bin/nordfileshare
		fowners root:nordvpn /usr/lib/nordvpn/nordfileshare
		fperms 0550 /usr/lib/nordvpn/nordfileshare
	fi

	# systemd units from upstream
	systemd_dounit contrib/systemd/system/nordvpnd.{service,socket}
	dotmpfiles contrib/systemd/tmpfiles.d/nordvpn.conf

	# OpenRC init script
	newinitd "${FILESDIR}/nordvpn.initd" nordvpn

	# Data directories
	keepdir /var/lib/nordvpn

	# Desktop file and icon
	domenu contrib/desktop/nordvpn.desktop
	insinto /usr/share/icons/hicolor/scalable/apps
	newins assets/icon.svg nordvpn.svg
}

pkg_postinst() {
	tmpfiles_process nordvpn.conf
	xdg_desktop_database_update
	xdg_icon_cache_update

	elog "To use NordVPN, add your user to the 'nordvpn' group:"
	elog "  usermod -aG nordvpn <user>"
	elog ""
	elog "Then start the daemon:"
	elog "  systemctl start nordvpnd  (systemd)"
	elog "  rc-service nordvpn start  (OpenRC)"
	elog ""
	elog "Login with: nordvpn login"
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_icon_cache_update
}
