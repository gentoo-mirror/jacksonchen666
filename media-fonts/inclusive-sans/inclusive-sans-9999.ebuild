# Copyright 2021-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# TODO: actual versioning (well that's if there's versioning upstream)
EAPI=8

inherit font git-r3

DESCRIPTION="A font designed for accessibility and readability"
HOMEPAGE="https://www.oliviaking.com/inclusive-sans"
#SRC_URI="https://github.com/LivKing/Inclusive-Sans/archive/refs/heads/main.tar.gz -> ${P}.gh.tar.gz"
SRC_URI=""
EGIT_REPO_URI="https://github.com/LivKing/Inclusive-Sans"

LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS=""
RESTRICT="test"

FONT_S="${S}/fonts/ttf"
FONT_SUFFIX="ttf"

src_compile() {
	return
}
