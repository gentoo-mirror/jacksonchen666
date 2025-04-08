# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Scrollable tiling Kwin script"
HOMEPAGE="https://github.com/peterfajdiga/karousel"
if [[ "${PV}" == *"9999"* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/peterfajdiga/karousel.git"
else
	SRC_URI="https://github.com/peterfajdiga/karousel/archive/tags/v${PV}.tar.gz -> ${PF}.tar.gz"
fi

# +?
LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""

# karousel depends on a few QML modules but i have no clue what any of that
# is, so best effort research
# - qtquick
# - org.kde.kwin
# - org.kde.notification
DEPEND="
	dev-qt/qtdeclarative
	kde-plasma/kwin
	kde-frameworks/knotifications
"
# use flag not present in newer :6 versions
#kde-frameworks/knotifications[qml]
RDEPEND="${DEPEND}"
BDEPEND="
	dev-lang/typescript
	net-libs/nodejs
"
IUSE="test"
RESTRICT="!test? ( test )"

src_compile() {
	emake TESTS=false build
}

src_test() {
	emake tests
}

src_install() {
	insinto /usr/share/kwin/scripts/
	mv package/ karousel/ || die "could not rename package/ folder"
	# `newins -r` not possible
	doins -r karousel
}
