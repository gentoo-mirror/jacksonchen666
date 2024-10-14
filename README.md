# jacksonchen666's personal ebuild repository and Gentoo overlay

This is a ebuild repository that is a Gentoo overlay. Could be both or
either. I'm not sure.

Contains stuff I want as packages on a Gentoo Linux system.

Bug reports and contributions currently go to `/dev/null` as I haven't setup
any infrastructure for those things.

<!-- update resources for development on contributions for this repo as well -->

## Quality

Not guaranteed. Insert all the disclaimers here of course.

There may be testing in x86_64/amd64, but since jacksonchen666's main Gentoo
machine runs on x86_64/amd64, packages will be less tested for arm64.

There may be attempts to follow Gentoo conventions for ebuilds and stuff,
but that's also not guaranteed.

Packages will only have an unstable keyword if it has been vaguely tested on
that architecture.

<!-- Note to self: https://projects.gentoo.org/qa/policy-guide/ -->

## Setup and usage

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

### Development setup

0. (Maybe?) Read the above setup process (or ignore it and do a full clone,
   idk)
1. Run `git remote set-url --push origin
   git@git.sr.ht:~jacksonchen666/gentoo-overlay` (if you have push access to
   the repository, somehow)
2. Install `dev-util/pkgdev` and prefer `pkgdev commit` over `git commit`
3. Do your work in `/var/db/repos/jacksonchen666/`
4. Maybe add `auto-sync = no` to the
   `/etc/portage/repos.conf/jacksonchen666.conf` file

## Potential caveats

jacksonchen666 also uses their Gentoo system with the systemd init system
instead of the OpenRC init system.

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
