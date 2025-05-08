# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# bumping: watch Makefile for changes, and update src_install, src_test, and
# maybe src_compile accordingly

DESCRIPTION="Interactive jq tool."
HOMEPAGE="https://codeberg.org/gpanders/ijq"
# TODO: 9999
SRC_URI="
	https://git.sr.ht/~gpanders/ijq/archive/v${PV}.tar.gz -> ${P}.tar.gz
	https://files.jacksonchen666.com/gentoo/${P}-vendor.tar.xz
"
# vendor tarball creation: take into account src_unpack, where ijq-v1.1.2 is
# renamed to ijq-1.1.2, and the vendor's dir is ijq-v1.1.2 (i.e. before
# rename)
#
# TODO: unbundling? (3 occurrences of #cgo but build success)

inherit go-module

LICENSE="GPL-3+"
# go deps, checked ijq 1.1.2
LICENSE+=" BSD MIT Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

IUSE="doc"
#DEPEND=""
RDEPEND="
	${DEPEND}
	app-misc/jq
"
BDEPEND="
	doc? (
		app-text/scdoc
	)
"
# no mirrors anyways
RESTRICT="mirror"

src_unpack() {
	default
	mv "${PN}-v${PV}" "${P}"
}

src_compile() {
	emake VERSION="${PVR}" ijq
	if use doc; then
		emake docs
	fi
}

src_install() {
	dodoc README.md
	dobin ijq
	if use doc; then
		doman ijq.1
	fi
}

src_test() {
	ego test -v .
}
