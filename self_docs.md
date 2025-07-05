## making go vendor/deps tarballs

1. comment out any vendor/deps `SRC_URI`s and related stuff
2. run `ebuild <ebuild filename> manifest unpack`
3. go to the work directory
4. go inside the directory with source code within the workdir (or `$S`)
5. get vendor/deps stuff
    - vendor (preferred): `go mod vendor`
    - deps (do note that it's necessary if necessary): `GOMODCACHE="${PWD}"/go-mod go mod download -modcacherw -x`
6. `cd ..` into the workdir
7. run one of the following commands depending on whether it's a vendor or
   deps

   ```
   XZ_OPT='-T0 -9' tar -acf ${P}-vendor.tar.xz ${P}/vendor/
   XZ_OPT='-T0 -9' tar -acf ${P}-deps.tar.xz ${P}/go-mod/
   ```
8. rsync to https://files.jacksonchen666.com/gentoo/
