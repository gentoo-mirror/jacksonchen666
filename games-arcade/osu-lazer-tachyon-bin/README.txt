Tachyon releases (pre-releases, unstable) are managed by having a separate
package.

An unmask would ignore any legitimate use of package masks.

It's not possible to do a keyword that allows amd64 only that isn't
specified and doesn't override the -* keyword. So a package mask with a
message would be the closest.

SLOTs weren't used as tying yourself to a specific slot will probably result
in being left on older versions.

If a release is pulled (which is probably hard to tell, GitHub releases may
not be the most useful way), it's best to remove it.
