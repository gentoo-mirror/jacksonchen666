# Copyright 2024 JacksonChen666
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit go-module
# update on every bump
GIT_COMMIT=d11b100

DESCRIPTION="Simple pub-sub notification service"
HOMEPAGE="https://ntfy.sh"
SRC_URI="https://github.com/binwiederhier/ntfy/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
# https://wiki.gentoo.org/wiki/Writing_go_Ebuilds#Vendor_tarball
SRC_URI+=" https://files.jacksonchen666.com/gentoo/${P}-vendor.tar.xz"
# node modules couldn't be figured out and isn't included, here's old notes:
# and after `npm i` in ./web/:
# tar --create --auto-compress --file ntfy-2.11.0-vendor.tar.xz ntfy-2.11.0/vendor ntfy-2.11.0/web/node_modules

# TODO: include other files as well
# https://github.com/binwiederhier/ntfy/blob/9d3fc20e583564e40af5afb90233f4714fdfcb4c/.goreleaser.yml#L82-L100

LICENSE="|| ( Apache-2.0 GPL-2 )"
# third party deps
# (https://wiki.gentoo.org/wiki/Writing_go_Ebuilds#Licenses)
#LICENSE+=" Apache-2.0 MIT BSD BSD-2"
SLOT="0"
KEYWORDS="~arm64"

# XXX: groups?
#DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND="
	server? (
		dev-python/mkdocs
		dev-python/mkdocs-material
		dev-python/mkdocs-minify-plugin
		net-libs/nodejs[npm]
	)
"
IUSE="+server"
# TODO: make test succeed
RESTRICT="test"
# XXX: try to not do this (doesn't work with npm and its vite)
RESTRICT+=" network-sandbox"

src_configure() {
	if use server; then
		GOFLAGS+=" -tags=sqlite_omit_load_extension,osusergo,netgo -ldflags=-linkmode=external -ldflags=-extldflags=-static -ldflags=-s -ldflags=-w"
		CGO_ENABLED=1
	else
		GOFLAGS+=" -tags=noserver"
		CGO_ENABLED=0
	fi
}

src_prepare() {
	if use server; then
		# NOT done in vendored tar
		emake -j1 web-deps
	fi

	default
}

src_compile() {
	if ! use server; then
		# filler files required, even when server isn't enabled
		emake cli-deps-static-sites
	fi

	if use server; then
		# pre-requisites, embedded in binary
		emake -j1 web-build
		mkdocs build
	fi

	# ldflags idea taken from dev-go/golangci-lint::gentoo
	ego build "${myargs[@]}" -ldflags "
		-X main.version=${PV}
		-X main.commit=${GIT_COMMIT}
		-X main.date=$(date -u +%Y-%m-%dT%H:%M:%SZ)"
}

src_install() {
	dobin ntfy
	# TODO: service files
	# TODO: openrc files? (local file?)
}
