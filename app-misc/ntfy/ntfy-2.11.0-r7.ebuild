# Copyright 2024 JacksonChen666
# Distributed under the terms of the GNU General Public License v2

# XXX: prepared cache directories (not via post install because QA notice)
# via dir creation in service files

EAPI=8
inherit go-module systemd
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

LICENSE="|| ( Apache-2.0 GPL-2 )"
# third party deps
# checked on ntfy 2.11.0
# (https://wiki.gentoo.org/wiki/Writing_go_Ebuilds#Licenses)
# TODO: check on npm (used for building web stuff)
LICENSE+=" Apache-2.0 MIT BSD BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"

DEPEND="
	acct-group/ntfy
	acct-user/ntfy
"
RDEPEND="${DEPEND}"
BDEPEND="
	doc? (
		dev-python/mkdocs
		dev-python/mkdocs-material
		dev-python/mkdocs-minify-plugin
	)
	server? (
		net-libs/nodejs[npm]
	)
	${DEPEND}
"
# XXX: default optional server?
IUSE="+server doc"
# TODO: make test succeed
RESTRICT="test"
# XXX: try to not do this (doesn't work with npm and its vite)
RESTRICT+=" network-sandbox"
# disabled due to lack of mirrors
RESTRICT+="mirror"

pkg_pretend() {
	if use server && ! use doc; then
		ewarn "server USE flag is enabled but doc USE flag isn't, documentation linked on"
		ewarn "the web UI will not be available!"
	fi
}

src_configure() {
	default

	# extracted from goreleaser files
	if use server; then
		GOFLAGS+=" -tags=sqlite_omit_load_extension,osusergo,netgo -ldflags=-linkmode=external -ldflags=-extldflags=-static -ldflags=-s -ldflags=-w"
		CGO_ENABLED=1
	else
		GOFLAGS+=" -tags=noserver"
		CGO_ENABLED=0
	fi
}

src_prepare() {
	default

	if use server; then
		# NOT done in vendored tar
		emake -j1 web-deps
	fi
}

src_compile() {
	emake cli-deps-static-sites

	# pre-requisites, embedded in binary
	if use server; then
		emake -j1 web-build
	fi
	if use doc; then
		mkdocs build || die
	fi

	# ldflags idea taken from dev-go/golangci-lint::gentoo
	ego build "${myargs[@]}" -ldflags "
		-X main.version=${PV}
		-X main.commit=${GIT_COMMIT}
		-X main.date=$(date -u +%Y-%m-%dT%H:%M:%SZ)"
}

src_install() {
	dobin ntfy

	# https://github.com/binwiederhier/ntfy/blob/9d3fc20e583564e40af5afb90233f4714fdfcb4c/.goreleaser.yml#L82-L100

	# random png
	insinto /usr/share/${PF}/
	cp web/public/static/images/ntfy.png web/public/static/images/logo.png || die
	doins web/public/static/images/logo.png
	chown -R ntfy:ntfy "${D}/usr/share/${PF}/" || die

	# configuration
	insinto /etc/${PN}/
	cp client/client.yml client/client.yml.example || die
	doins client/client.yml.example
	if use server; then
		cp server/server.yml server/server.yml.example || die
		doins server/server.yml.example
	fi
	chown -R ntfy:ntfy "${D}/etc/${PN}/" || die
	chmod -R u=rwX,g=rX "${D}/etc/${PN}/" || die

	# referenced folders in example config
	dodir /var/lib/${PN}/
	keepdir /var/lib/${PN}/
	chown -R ntfy:ntfy "${D}/var/lib/${PN}/" || die
	chmod -R u=rwX,g=rX "${D}/var/lib/${PN}/" || die

	# init files
	systemd_dounit client/ntfy-client.service
	doinitd "${FILESDIR}"/init.d/ntfy-client
	doconfd "${FILESDIR}"/conf.d/ntfy-client
	if use server; then
		systemd_dounit server/ntfy.service
		doinitd "${FILESDIR}"/init.d/ntfy
		doconfd "${FILESDIR}"/conf.d/ntfy
	fi

	# docs
	HTML_DOCS="server/docs/" einstalldocs
}
