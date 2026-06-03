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
  stdenv,
  pkgsCross,
  gmp,
  libmpc,
  mpfr,
  zlib,
  libiconv,
  gettext,
  centos7-sysroot,
  gcc15,
}:

let
  targetTriple = "x86_64-unknown-linux-gnu";
in

stdenv.mkDerivation {
  pname = "x86_64-unknown-linux-gnu217-gcc-sysroot";
  inherit (gcc15.cc) src version;

  hardeningDisable = [ "all" ];

  nativeBuildInputs = [
    gmp
    libmpc
    mpfr
    pkgsCross.gnu64.buildPackages.binutils
    zlib
    libiconv
    gettext
  ];

  configurePlatforms = [
    "build"
    "host"
  ];

  configureFlags = [
    "--disable-bootstrap"
    "--enable-languages=c,c++"
    "--disable-multilib"
    "--disable-nls"
    "--disable-libstdcxx-pch"
    "--with-sysroot=${centos7-sysroot}"
    "--target=${targetTriple}"
    "--with-system-zlib"
  ];

  preConfigure = ''
    mkdir build
    cd build
  '';

  configureScript = "../configure";

  buildPhase = ''
    runHook preBuild

    make -j$NIX_BUILD_CORES all-gcc
    make -j$NIX_BUILD_CORES all-target-libgcc
    make -j$NIX_BUILD_CORES all-target-libstdc++-v3

    runHook postBuild
  '';

  installTargets = "install-target-libgcc install-target-libstdc++-v3";

  postInstall = ''
    if [ -d "$out/${targetTriple}/" ];then
      cp $out/${targetTriple}/* $out -rf
      rm $out/${targetTriple} -rf
    fi
  '';

  dontFixup = true;
}
