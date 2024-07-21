# Copyright 2024 JacksonChen666
# Distributed under the terms of the GNU General Public License v2

# TODO: verify-sig

EAPI=8
inherit go-module systemd

DESCRIPTION="A bridge between ntfy and Alertmanager"
HOMEPAGE="https://hub.xenrox.net/~xenrox/ntfy-alertmanager/"
SRC_URI="https://git.xenrox.net/~xenrox/ntfy-alertmanager/refs/download/v${PV}/${P}.tar.gz"
# https://wiki.gentoo.org/wiki/Writing_go_Ebuilds#Vendor_tarball
SRC_URI+=" https://files.jacksonchen666.com/gentoo/${P}-vendor.tar.xz"

LICENSE="AGPL-3"
# third party deps
# checked on ntfy-alertmanager 0.3.0
# (https://wiki.gentoo.org/wiki/Writing_go_Ebuilds#Licenses)
LICENSE+=" MIT BSD BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
# disabled due to lack of mirrors
RESTRICT="mirror"

DEPEND="
	acct-group/ntfy-alertmanager
	acct-user/ntfy-alertmanager
"

src_compile() {
	ego build -ldflags "-X main.version=v${PV}"
}

src_install() {
	default

	dobin ntfy-alertmanager

	# configuration
	insinto /etc/${PN}/
	newins config.scfg config
	chown -R ntfy-alertmanager:ntfy-alertmanager "${D}/etc/${PN}/" || die
	chmod -R u=rwX,g=rX "${D}/etc/${PN}/" || die

	# init files
	doinitd "${FILESDIR}/init.d/ntfy-alertmanager"
	doconfd "${FILESDIR}/conf.d/ntfy-alertmanager"
	systemd_dounit "${FILESDIR}/ntfy-alertmanager.service"
}

src_test() {
	ego test -v ./...
}
