# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module

DESCRIPTION="Some words here"
HOMEPAGE="https://github.com/binwiederhier/ntfy"
#SRC_URI="https://github.com/binwiederhier/ntfy/archive/refs/tags/v2.11.0.tar.gz"
# TODO: put the vendor actually somewhere instead of a temporary place
# TODO: other versions?
SRC_URI="https://github.com/binwiederhier/ntfy/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://files.jacksonchen666.com/tmp/${P}-vendor.tar.xz"
# XXX: figure out available architectures and how to build tem

# TODO: check with third party deps
LICENSE="|| ( Apache-2.0 GPL-2 )"
SLOT="0"
KEYWORDS=""
IUSE=""

# TODO: USE flags to control building of docs and web app

DEPEND=""
RDEPEND="${DEPEND}"
# TODO
BDEPEND=""

src_configure() {
	#GOFLAGS+=" -tags=sqlite_omit_load_extension,osusergo,netgo -linkmode=external -extldflags=-static -s -w -X main.version={{.Version}} -X main.commit={{.Commit}} -X main.date={{.Date}}"
	#GOFLAGS+=" -tags=sqlite_omit_load_extension,osusergo,netgo"
	# XXX: check goreleaser and do something like that
	GOFLAGS+=" -tags=sqlite_omit_load_extension,osusergo,netgo -extldflags=-static -s -w -X main.version={{.Version}} -X main.commit={{.Commit}} -X main.date={{.Date}}"
}

src_compile() {
    #ego build

	# XXX: explore other targets
	# go check the upstream .goreleaser.yml file:
	#emake cli-linux-server

	# https://docs.ntfy.sh/develop/
	emake cli-deps-static-sites

	# XXX: USE flag-ify (not possible for test probably)
	# must be done in order, can't be parallelized anyways
	emake web -j1

	#CGO_ENABLED=1 ego build -linkmode=external -extldflags=-static -s -w -X main.version="{{.Version}}" -X "main.commit={{.Commit}}" -X "main.date={{.Date}}"
	CGO_ENABLED=1 ego build
}

# TODO: tests that work with web disabled?
# cause default works but then uh... it fails with web disabled?
# TODO: test the tests
#src_test() {
#	emake test
#}

src_install() {
	#die "not implemented"

    dobin ntfy
	# TODO: service files
	# TODO: openrc files? (local file?)

	#emake DESTDIR="${D}" install-linux-arm64
}
