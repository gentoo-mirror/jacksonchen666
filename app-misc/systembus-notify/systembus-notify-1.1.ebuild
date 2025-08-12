# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit systemd

DESCRIPTION="Send desktop notifications from the system bus to the user bus"
HOMEPAGE="https://github.com/rfjakob/systembus-notify"
SRC_URI="https://github.com/rfjakob/systembus-notify/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

# TODO
DEPEND="
	sys-apps/systemd
"
RDEPEND="${DEPEND}"
BDEPEND="
	test? (
		dev-util/cppcheck
		sys-apps/dbus
	)
"
IUSE="test"

RESTRICT="!test? ( test )"

src_install() {
	# emulate makefile but do things correctly
	# and systemd user service instead
	default
	dobin "${S}/systembus-notify"
	systemd_douserunit "${FILESDIR}/systembus-notify.service"
}

pkg_postinst() {
	elog "Please report issues regarding the systemd unit to jacksonchen666, not upstream."
	elog ""
	elog "Untrusted users can cause a denial-of-service by spamming notifications. Pending"
	elog "https://github.com/rfjakob/systembus-notify/issues/9"
	elog ""
	elog "Gentoo's own earlyoom will not have functional notifications without editing the"
	elog "systemd unit to disable DynamicUsers (a user can be manually specified, like"
	elog "nobody)."
	elog "See https://github.com/rfjakob/earlyoom/issues/270#issuecomment-1155020972"
}
