# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=poetry
PYTHON_COMPAT=( python3_{9..13} pypy3 )
inherit distutils-r1

DESCRIPTION="A simple deSEC.io API client"
HOMEPAGE="https://github.com/s-hamann/desec-dns"
# upstream provided tarballs does not include tests
SRC_URI="https://github.com/s-hamann/desec-dns/archive/v${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""

# TODO: python requirements:
# requests
# cryptography (optional, for high-level management of TLSA records)
# dnspython (optional, for parsing zone files)
#
# TODO: 9999 (pyproject versioning?)

# TODO: USE flags (match python pip things):
# - zonefiles
# - tlsa
# TODO: use flags with poetry (yeah)
# TODO: post-install messages instead of USE flags? (deps won't change
# code...)
#dev-python/cryptography
#dev-python/dnspython

# testing required:
# pytest (implicit? add to deps?)
# pytest-recording
#
# TODO: move test conditional to BDEPEND?
# TODO: dnspython required in some tests, check what to do about that
#
# TODO: test TLSA
# TODO: test zonefiles
IUSE="test"
DEPEND="
	dev-python/requests
	test? (
		dev-python/dnspython
		dev-python/pytest-recording
	)
"
RDEPEND="${DEPEND}"
BDEPEND="
"

distutils_enable_tests pytest

src_prepare() {
	default

	# https://projects.gentoo.org/python/guide/qawarn.html#stray-top-level-files-in-site-packages
	sed -i 's/include = \["CHANGELOG.md"\]//' pyproject.toml || die "failed to sed pyproject.toml (exclude CHANGELOG.md)"

	sed -i 's/version = "0.0.0"/version = "v'${PV}'"/' pyproject.toml || die "failed to sed pyproject.toml (fix version)"
}

#src_install() {
#	default
#	dodoc "CHANGELOG.md"
#}

#python_install() {
#	default
#
#	poetry install
#}

#python_install_all() {
#	default
#
#	poetry install
#}
