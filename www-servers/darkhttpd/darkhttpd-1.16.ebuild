# Copyright 2024 JacksonChen666
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="When you need a web server in a hurry"
HOMEPAGE="https://unix4lyfe.org/darkhttpd/"
SRC_URI="https://github.com/emikulic/darkhttpd/archive/v${PV}.tar.gz -> ${P}.tar.gz"
# tests fail
RESTRICT="test"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64"

src_install() {
	dodoc README.md
	dobin "${PN}"
}
