# Copyright 2024 JacksonChen666
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit go-module
# update on every bump
GIT_COMMIT=d11b100

DESCRIPTION="HTTP-based pub-sub notification service"
HOMEPAGE="https://github.com/binwiederhier/ntfy"
SRC_URI="https://github.com/binwiederhier/ntfy/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
# TODO: put the vendor actually somewhere instead of a temporary place
SRC_URI+=" https://files.jacksonchen666.com/tmp/${P}-vendor.tar.xz"

# TODO: 9999
# TODO: check with third party deps
LICENSE="Apache-2.0 GPL-2"
SLOT="0"
KEYWORDS="~arm64"

# XXX: groups?
#DEPEND=""
RDEPEND="${DEPEND}"
# TODO
BDEPEND="
	dev-python/mkdocs
	dev-python/mkdocs-material
	dev-python/mkdocs-minify-plugin
	net-libs/nodejs[npm]
"

src_configure() {
	GOFLAGS+=" -tags=sqlite_omit_load_extension,osusergo,netgo -ldflags=-linkmode=external -ldflags=-extldflags=-static -ldflags=-s -ldflags=-w"
}

src_compile() {
	emake cli-deps-static-sites

	# pre-requisites, embedded in binary
	# must be done in order, can't be parallelized anyways
	# TODO: deal with network sandbox
	emake -j1 web
	mkdocs build

	# ldflags idea taken from dev-go/golangci-lint::gentoo
	CGO_ENABLED=1 ego build "${myargs[@]}" -ldflags "
		-X main.version=${PV}
		-X main.commit=${GIT_COMMIT}
		-X main.date=$(date -u +%Y-%m-%dT%H:%M:%SZ)"
}

# TODO: test the tests

src_install() {
	dobin ntfy
	# TODO: service files
	# TODO: openrc files? (local file?)
}
