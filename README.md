# jacksonchen666's personal ebuild repository and Gentoo overlay

This is a ebuild repository that is a Gentoo overlay. Could be both or
either. I'm not sure.

Contains stuff I want as packages on a Gentoo Linux system.

Bug reports outside of Gentoo's Bugzilla and all patches are currently being
redirected to `/dev/null` as the infrastructure currently doesn't exist yet.

<!-- update resources for development on contributions for this repo as well -->

## Bug reporting

You can [make a bug report on the Gentoo Bugzilla][gbugzilla] (requires
account). The "Product" should be "Gentoo Linux" and the "Component" should
be "Overlay", which are ensured with the link. Attachments can be added
after submitting your bug report.

The summary should include "jacksonchen666" somewhere, like in a package
atom as `::jacksonchen666`, or there should be something like
`[jacksonchen666]` prefixed, so bugs regarding this overlay can be easily
found.

[gbugzilla]:https://bugs.gentoo.org/enter_bug.cgi?product=Gentoo%20Linux&component=Overlays&format=guided

([Expert bug report mode][gbugexpert])

[gbugexpert]:https://bugs.gentoo.org/enter_bug.cgi?product=Gentoo%20Linux&component=Overlays

## Quality

Not guaranteed. Insert all the disclaimers here of course.

jacksonchen666's main Gentoo machine runs on x86_64/amd64, so packages will
be less tested for arm64. Outside of that, there is no testing for
architectures in x86_64/amd64 or arm64.

There may be attempts to follow Gentoo conventions for ebuilds and stuff,
but that's also not guaranteed.

Packages will only have an unstable keyword if it has been vaguely tested on
that architecture.

<!-- Note to self: https://projects.gentoo.org/qa/policy-guide/ -->

## Setup and usage

1. `emerge --ask --noreplace app-eselect/eselect-repository dev-vcs/git` to
   get the program necessary to enable and sync the repository (see "Old
   manual setup instructions" if you don't want
   `app-eselect/eselect-repository`)
2. Add repository by running `eselect repository enable jacksonchen666`
3. `emerge --sync jacksonchen666` (or use `emaint`) should get you up to
   date.

### Development setup

0. (Maybe?) Read the "Old manual setup instructions" process (or ignore it
   and do a full clone, idk)
1. Run `git remote set-url --push origin
   git@git.sr.ht:~jacksonchen666/gentoo-overlay` (if you have push access to
   the repository, somehow)
2. Install `dev-util/pkgdev` and prefer `pkgdev commit` over `git commit`
3. Do your work in `/var/db/repos/jacksonchen666/`
4. Maybe add `auto-sync = no` to the
   `/etc/portage/repos.conf/jacksonchen666.conf` file

### Old manual setup instructions

Put the following thing in `/etc/portage/repos.conf/jacksonchen666.conf`

```ini
[jacksonchen666]
location = /var/db/repos/jacksonchen666
sync-type = git
sync-uri = https://git.sr.ht/~jacksonchen666/gentoo-overlay
priority = 100
```

Then `emerge --sync jacksonchen666` (or use `emaint`) should get you up to
date.

## Potential caveats

jacksonchen666 uses their Gentoo system with the systemd init system instead
of the OpenRC init system. OpenRC will be sparsely tested.

See also the ["Quality" section](#quality)

### Uptime and Availability

About 50% of the ebuilds in this overlay (including different versions for
the same atom/name) uses <https://files.jacksonchen666.com/gentoo/> to fetch
more sources in addition to upstream source code. This means the ability to
download sources and compile packages depends on the self-hosted server of
jacksonchen666.com, with its status being available at
<https://status.jacksonchen666.com>.

Another dependency of "has to be online to work" is git.sr.ht for grabbing
the ebuilds (although local copies are stored on your system). No mirrors
currently exist.

Of course, there's also the source files themselves from anywhere, including
code forges, mostly GitHub. There is also no mirroring of that, since this
repository isn't the official Gentoo repository.

## License

Pretty much everything is GPL-v2 here. Well, the ebuilds. Not the things it
downloads or compiles or installs.

## Resources for development

If you want to make your own ebuild repository (or contribute to this one,
if contributions are open (it is not)), here's some helpful
resources:
- [Basic guide to write Gentoo Ebuilds](https://wiki.gentoo.org/wiki/Basic_guide_to_write_Gentoo_Ebuilds) (especially the "See also" section)
- [Creating an ebuild repository](https://wiki.gentoo.org/wiki/Eselect/Repository#Create_a_new_ebuild_repository)
- <https://devmanual.gentoo.org/>
- <https://wiki.gentoo.org/wiki/Ebuild_repository>
- [Listing your ebuild repository in `eselect repositories`](https://wiki.gentoo.org/wiki/Project:Overlays/Overlays_guide)
- <https://repos.gentoo.org/>
- [eclass reference](https://devmanual.gentoo.org/eclass-reference/)
