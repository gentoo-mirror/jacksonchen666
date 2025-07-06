# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module

DESCRIPTION="Command line interface for LibreSpeed speed test backends"
HOMEPAGE="https://github.com/librespeed/speedtest-cli"

SRC_URI="
	https://github.com/librespeed/speedtest-cli/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	https://files.jacksonchen666.com/gentoo/librespeed-cli-${PV}-vendor.tar.xz
"

# TODO: LGPL-3 or later?
LICENSE="LGPL-3"
# deps license checked as of 7573b65ebc89a4cf463334dbdfab5b3edc706149
LICENSE+=" Apache-2.0 MIT BSD BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

#DEPEND=""
RDEPEND="${DEPEND}"
# go version from go.mod
BDEPEND=">=dev-lang/go-1.18"
RESTRICT="mirror"

src_unpack() {
	unpack ${P}.tar.gz
	mv speedtest-cli-${PV} librespeed-cli-${PV}
	S="${S/speedtest-cli/librespeed-cli}"

	unpack librespeed-cli-${PV}-vendor.tar.xz
}

src_compile() {
	DEFS_PATH="github.com/librespeed/speedtest-cli"
	ego build -ldflags "-w -s -X \"${DEFS_PATH}/defs.ProgName=${PN}\" \
		-X \"${DEFS_PATH}/defs.ProgVersion=${PV}\"
		-X \"${DEFS_PATH}/defs.BuildDate=$(date -u "+%Y-%m-%d %H:%M:%S %Z")\"" \
		-o librespeed-cli -trimpath main.go
}

src_install() {
	default

	dobin librespeed-cli
}
