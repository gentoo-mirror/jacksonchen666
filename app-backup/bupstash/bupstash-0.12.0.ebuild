# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Autogenerated by pycargoebuild 0.13.3

EAPI=8

CRATES="
	ahash@0.7.6
	aho-corasick@0.7.18
	anyhow@1.0.56
	arrayref@0.3.6
	arrayvec@0.7.2
	atty@0.2.14
	autocfg@1.1.0
	bitflags@1.3.2
	blake3@1.3.1
	block-buffer@0.10.2
	bstr@0.2.17
	cc@1.0.73
	cfg-if@0.1.10
	cfg-if@1.0.0
	chrono@0.4.19
	codemap-diagnostic@0.1.1
	codemap@0.1.3
	console@0.15.0
	constant_time_eq@0.1.5
	crossbeam-channel@0.5.6
	crossbeam-utils@0.8.11
	crypto-common@0.1.3
	digest@0.10.3
	either@1.6.1
	encode_unicode@0.3.6
	fallible-iterator@0.2.0
	fallible-streaming-iterator@0.1.9
	fastrand@1.7.0
	filetime@0.2.15
	fnv@1.0.7
	generic-array@0.14.5
	getopts@0.2.21
	getrandom@0.2.5
	globset@0.4.8
	hashbrown@0.11.2
	hashlink@0.7.0
	hermit-abi@0.1.19
	humantime@2.1.0
	indicatif@0.16.2
	instant@0.1.12
	itertools@0.10.3
	itoa@1.0.1
	jobserver@0.1.24
	lazy_static@1.4.0
	libc@0.2.120
	libsqlite3-sys@0.22.2
	log@0.4.14
	lz4-sys@1.9.4
	lz4@1.24.0
	memchr@2.4.1
	memoffset@0.6.5
	nix@0.23.1
	num-integer@0.1.44
	num-traits@0.2.14
	num_cpus@1.13.1
	number_prefix@0.4.0
	once_cell@1.10.0
	path-clean@0.1.0
	pkg-config@0.3.24
	plmap@0.3.0
	ppv-lite86@0.2.16
	proc-macro2@1.0.36
	quote@1.0.15
	rand@0.8.5
	rand_chacha@0.3.1
	rand_core@0.6.3
	rangemap@0.1.14
	redox_syscall@0.2.11
	regex-syntax@0.6.25
	regex@1.5.5
	remove_dir_all@0.5.3
	rusqlite@0.25.4
	ryu@1.0.9
	same-file@1.0.6
	serde@1.0.136
	serde_bare@0.4.0
	serde_derive@1.0.136
	serde_json@1.0.79
	shlex@0.1.1
	smallvec@1.8.0
	subtle@2.4.1
	syn@1.0.88
	tar@0.4.38
	tempfile@3.3.0
	termcolor@1.1.3
	terminal_size@0.1.17
	thiserror-impl@1.0.30
	thiserror@1.0.30
	time@0.1.43
	typenum@1.15.0
	unicode-width@0.1.9
	unicode-xid@0.2.2
	uriparse@0.6.4
	vcpkg@0.2.15
	version_check@0.9.4
	walkdir@2.3.2
	wasi@0.10.2+wasi-snapshot-preview1
	winapi-i686-pc-windows-gnu@0.4.0
	winapi-util@0.1.5
	winapi-x86_64-pc-windows-gnu@0.4.0
	winapi@0.3.9
	xattr@0.2.2
	zstd-safe@4.1.4+zstd.1.5.2
	zstd-sys@1.6.3+zstd.1.5.2
"

inherit cargo

DESCRIPTION="Easy and efficient encrypted backups."
HOMEPAGE="https://bupstash.io/"
SRC_URI="
	https://github.com/andrewchambers/bupstash/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	${CARGO_CRATE_URIS}
"

LICENSE="MIT"
# Dependent crate licenses
# found with dev-util/cargo-license
LICENSE+="
	BSD BSD-2 CC0-1.0 MIT
	|| ( Apache-2.0 Apache-2.0-with-LLVM-exceptions MIT )
	|| ( Apache-2.0 Boost-1.0 )
	|| ( Apache-2.0 CC0-1.0 )
	|| ( Apache-2.0 MIT )
	|| ( MIT Unlicense )
"

SLOT="0"
KEYWORDS="~amd64"
DEPEND="man? ( app-text/ronn-ng )"
BDEPEND="
	${DEPEND}
	virtual/pkgconfig
	app-arch/zstd
	app-arch/lz4
"
# TODO: libsodium?
# TODO: test on a system with none of these
IUSE="man"

QA_FLAGS_IGNORED="usr/bin/bupstash"

export PKG_CONFIG_ALLOW_CROSS=1
# TODO: unbundle lz4-sys libsqlite3-sys
# unbundling -sys crates
export ZSTD_SYS_USE_PKG_CONFIG=1

src_compile() {
	default
	cargo_src_compile

	if use man; then
		ronn -r doc/man/*.md
	fi
}
src_install() {
	default
	# TODO: does this compile twice???
	cargo_src_install

	if use man; then
		doman doc/man/*.?
	fi
}
