# Copyright 2025-present aberter0x3f
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
{
  stdenvNoCC,
  fetchurl,
  rpm,
  cpio,
}:

stdenvNoCC.mkDerivation {
  pname = "x86_64-unknown-linux-gnu217-centos7-sysroot";
  version = "2.17";

  srcs = [
    (fetchurl {
      url = "https://vault.centos.org/7.9.2009/os/x86_64/Packages/glibc-2.17-317.el7.x86_64.rpm";
      hash = "sha256-SesIHeHd0T9UQKvbs7Qs3QHRG3TWJHk64bgKHPQyVRs=";
    })
    (fetchurl {
      url = "https://vault.centos.org/7.9.2009/os/x86_64/Packages/glibc-devel-2.17-317.el7.x86_64.rpm";
      hash = "sha256-V+BFI7EsmqWgYyy/ov8T4z8ezsXmvQtgmnfZwkzr+MQ=";
    })
    (fetchurl {
      url = "https://vault.centos.org/7.9.2009/os/x86_64/Packages/glibc-headers-2.17-317.el7.x86_64.rpm";
      hash = "sha256-t+ThmzYsvXPgnm7l7/PXDb63zCxwKpJ7j2RvMk1OxKM=";
    })
    (fetchurl {
      url = "https://vault.centos.org/7.9.2009/os/x86_64/Packages/kernel-headers-3.10.0-1160.el7.x86_64.rpm";
      hash = "sha256-gbTk9AHSQCc2zrpGJ+qv1bYVwsxFqk1PlB6nlWIEUTk=";
    })
  ];

  nativeBuildInputs = [
    rpm
    cpio
  ];

  unpackPhase = ''
    runHook preUnpack

    mkdir -p source
    cd source
    for pkg in $srcs; do
      rpm2cpio $pkg | cpio -idmv
    done

    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp -a * $out/

    ln -s lib64 $out/lib
    ln -s lib64 $out/usr/lib

    runHook postInstall
  '';

  # Strip absolute paths to make them relative to the sysroot
  fixupPhase = ''
    runHook preFixup

    sed -i 's|/usr/lib64/||g; s|/lib64/||g' $out/usr/lib64/libc.so
    sed -i 's|/usr/lib64/||g; s|/lib64/||g' $out/usr/lib64/libpthread.so

    runHook postFixup
  '';

  # Do not let patchelf modify these standard sysroot libraries
  dontPatchELF = true;
}
