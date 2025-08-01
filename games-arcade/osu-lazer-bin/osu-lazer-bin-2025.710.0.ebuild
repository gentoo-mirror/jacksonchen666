# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop xdg-utils

DESCRIPTION="A free-to-win rhythm game (Upstream binary builds)"
HOMEPAGE="https://osu.ppy.sh/
	https://github.com/ppy/osu/"

SRC_URI="
	https://github.com/ppy/osu/releases/download/${PV}-lazer/osu.AppImage
		-> ${P}.AppImage
"

# "all-rights-reserved" - ships a copy of proprietary BASS lib - https://www.un4seen.com
LICENSE="Apache-2.0 BSD-2 LGPL-2.1 LGPL-3+ MIT all-rights-reserved"
# https://github.com/ppy/osu-resources
# CC BY-NC 4.0 + fonts
# https://github.com/ppy/osu-resources/blob/master/osu.Game.Resources/Fonts/Inter/OFL.txt
# https://github.com/ppy/osu-resources/blob/master/osu.Game.Resources/Fonts/Noto/LICENSE.txt - Apache 2.0
# https://github.com/ppy/osu-resources/blob/master/osu.Game.Resources/Fonts/Torus-Alternate/LICENCE - commercial license for distribution
# https://github.com/ppy/osu-resources/blob/master/osu.Game.Resources/Fonts/Torus/LICENCE           - commercial license for distribution
# https://github.com/ppy/osu-resources/blob/master/osu.Game.Resources/Fonts/Venera/LICENCE          - commercial license for distribution
LICENSE+=" CC-BY-NC-4.0 OFL-1.1 Apache-2.0 all-rights-reserved"

SLOT="0"
KEYWORDS="-* ~amd64"
IUSE="force-wayland"

# do not allow simultaneous installation of non-tachyon and tachyon
# releases. while it's possible to have both, usage flow hasn't been thought
# out, and constantly switching versions by accident (via desktop
# environment search picking things differently sometimes) could cause
# issues.
RDEPEND="!games-arcade/osu-lazer-tachyon-bin"

# because redistribution is not allowed without a commercial license, binary
# packages should not exist either
RESTRICT="bindist"
# also it's an upstream binary we don't have control over, so don't bother
RESTRICT+=" binchecks"
# let's also not touch the binaries
RESTRICT+=" strip"
# not source code-based ebuild
RESTRICT+=" test"
# non-redistributable things too, also no mirrors exist for this repo
RESTRICT+=" mirror"

# TODO: mimetype icons

unsupported_warning() {
	elog "This ebuild is unsupported by osu!lazer developers. If you encounter issues"
	elog "using osu!lazer (installed from this ebuild), please check if you can reproduce"
	elog "a bug using developer provided AppImages first before asking/reporting to them."
	elog "AppImages can be found at https://github.com/ppy/osu/releases/latest."
	elog ""
	elog "If you're sure or unsure whether an issue is caused by this ebuild, please"
	elog "report it to https://todo.sr.ht/~jacksonchen666/gentoo-overlay."
	# for tachyon release streams only, uncomment manually
	#elog ""
	#elog "A Tachyon release is being installed. This can potentially be unstable."
	#elog ""
	#elog "If Tachyon unstable releases are desired, the release stream should be updated"
	#elog "within osu!lazer anyways (to receive update notifications)."
}

pkg_pretend() {
	unsupported_warning
}

src_unpack() {
	cp "${DISTDIR}/${P}.AppImage" "${WORKDIR}" || die "can't copy sources"
	chmod +x "${WORKDIR}/${P}.AppImage" || die "couldn't make appimage executable"
	"${WORKDIR}/${P}.AppImage" --appimage-extract || die "couldn't extract appimage"
	mv squashfs-root "${S}" || die "couldn't rename extracted"
}

src_compile() {
	#cd "${S}" || die
	mkdir opt/ || die
	mv "usr/bin" "opt/${P}" || die

	# rename for clarity
	sed -i 's~^Name=.*~Name=osu!(lazer)~' osu\!.desktop || die "sed for .desktop name failed"

	# wrapper
	# probably not supported by devs
	if use force-wayland; then
		cp "${FILESDIR}/wayland-osu-lazer-bin" "./osu-lazer-bin" || die "cp failed"
	else
		cp "${FILESDIR}/osu-lazer-bin" . || die "cp failed"
	fi
	sed -i -e "s/%P%/${P}/" "osu-lazer-bin" || die "sed for wrapper failed"
	chmod +x osu-lazer-bin || die "chmod failed"
	sed -i "s~^Exec=.*~Exec=/usr/bin/osu-lazer-bin %u~" osu\!.desktop || die "sed for .desktop exec failed"
}

src_install() {
	# wrapper
	dobin osu-lazer-bin

	# actual binaries and libraries and etc.
	insinto /usr/share/icons/
	doins -r "usr/share/icons/hicolor/"
	insinto /opt/
	doins -r "opt/${P}/"

	# does not match upstream with a bunch of executable .dll files (some
	# excluded), which is probably done by dotnet
	fperms 0755 "/opt/${P}/osu!"

	domenu osu\!.desktop
}

pkg_postinst() {
	unsupported_warning
	xdg_icon_cache_update
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_icon_cache_update
	xdg_desktop_database_update
}
