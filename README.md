## x86_64-linux-gnu2.17-cross

This repository provides a small Nix flake for building an `x86_64-unknown-linux-gnu` cross-compilation toolchain that targets a glibc 2.17 runtime baseline.

The toolchain is assembled from three packages:

- `centos7-sysroot`: a CentOS 7 sysroot extracted from upstream RPMs.
- `gcc-sysroot`: GCC runtime headers and libraries built against that sysroot.
- `clang`: a wrapped Clang frontend configured to use the sysroot, GCC runtime, and `lld`.

The default package is the wrapped Clang toolchain.

## Outputs

The flake exports the following packages for each supported host system:

- `packages.<system>.centos7-sysroot`.
- `packages.<system>.gcc-sysroot`.
- `packages.<system>.clang`.
- `packages.<system>.default`.

Supported host systems:

- `x86_64-linux`.
- `aarch64-linux`.
- `x86_64-darwin`.
- `aarch64-darwin`.

## Notes

- The target triple passed to Clang is `x86_64-unknown-linux-gnu`.
- The wrapped compiler is configured with a CentOS 7 sysroot and a glibc 2.17 dynamic linker path.
- The project currently relies on upstream CentOS 7 RPM artifacts hosted on `vault.centos.org`.
- Third-party CentOS RPM contents remain governed by their own licenses and are not covered by this repository's Apache-2.0 license.
