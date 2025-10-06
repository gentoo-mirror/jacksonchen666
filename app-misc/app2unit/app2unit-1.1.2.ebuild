# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Launch Desktop Entries as Systemd user units"
HOMEPAGE="https://github.com/Vladimir-csp/app2unit"
SRC_URI="https://github.com/Vladimir-csp/app2unit/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
#S="${WORKDIR}/${PN}-v${PV}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
	sys-apps/systemd
"
RDEPEND="${DEPEND}"
BDEPEND="
	app-text/scdoc
"

src_compile() {
	# docs separately because QA do-compress complaints
	scdoc < app2unit.1.scd > app2unit.1
}

src_install() {
	export prefix=/usr

	emake DESTDIR="${D}" install-bin
	# docs separately because QA do-compress complaints
	dodoc app2unit.1
}
