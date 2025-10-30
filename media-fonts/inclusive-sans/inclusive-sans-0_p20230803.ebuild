# Copyright 2021-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit font

DESCRIPTION="A font designed for accessibility and readability"
HOMEPAGE="https://www.oliviaking.com/inclusivesans/feature"

if [[ "${PV}" == *"9999"* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/LivKing/Inclusive-Sans"
else
	GIT_COMMIT=97577e1a7c08db105c19bae35ea17b1a8f81ec5e
	SRC_URI="
		https://github.com/LivKing/Inclusive-Sans/archive/${GIT_COMMIT}.tar.gz
			-> ${P}.gh.tar.gz
	"
	S="${WORKDIR}/Inclusive-Sans-${GIT_COMMIT}"
fi

LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
RESTRICT="test mirror"

FONT_S="${S}/fonts/ttf"
FONT_SUFFIX="ttf"

src_compile() {
	return
}
