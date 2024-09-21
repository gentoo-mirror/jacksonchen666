# Copyright 2024 JacksonChen666
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="PipeWire audio capturing for OBS Studio"
HOMEPAGE="https://obsproject.com/forum/resources/pipewire-audio-capture.1458/"
SRC_URI="https://github.com/dimtpap/obs-pipewire-audio-capture/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
	media-video/wireplumber
	>=media-video/obs-studio-28.0.0
	>=media-video/pipewire-0.3.62
"
RDEPEND="
	${DEPEND}
"
BDEPEND="
	dev-build/cmake
"
# no tests
RESTRICT="test"
# disabled due to lack of mirrors
RESTRICT+=" mirror"

src_configure() {
	default
	cmake -B build -DCMAKE_INSTALL_PREFIX="/usr" -DCMAKE_BUILD_TYPE=RelWithDebInfo
}

src_compile() {
	cd build
	emake
}

src_install() {
	dodoc README.md
	cd build
	emake install
}
