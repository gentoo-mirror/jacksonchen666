# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# TODO: test
PYTHON_COMPAT=( python3_{9..13} )

#inherit meson ninja-utils desktop gnome2-utils
inherit meson gnome2-utils python-single-r1

# TODO: l10n USE
# TODO: deps (find, bare system)
# TODO: deps (sort into DEPEND and RDEPEND)

DESCRIPTION="Listen to ambient sounds"
HOMEPAGE="https://apps.gnome.org/Blanket/"
SRC_URI="https://github.com/rafaelmardojai/blanket/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
# sounds licensing
LICENSE+=" CC0-1.0 CC-BY-4.0 CC-BY-3.0 CC-BY-SA-4.0 public-domain"
SLOT="0"
KEYWORDS="~amd64"

	#dev-lang/python
DEPEND="
	dev-python/pygobject
	gui-libs/gtk:4
	media-libs/gstreamer

	dev-libs/appstream
	sys-devel/gettext
	dev-util/desktop-file-utils
	dev-util/blueprint-compiler
"
RDEPEND="${DEPEND} ${PYTHON_DEPS}"
BDEPEND="
	>=gui-libs/libadwaita-1.5.0

	dev-build/meson
	app-alternatives/ninja
"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"
RESTRICT="mirror"

pkg_postinst() {
	xdg_desktop_database_update
	gnome2_schemas_update
}

pkg_postrm() {
	xdg_desktop_database_update
	gnome2_schemas_update
}
