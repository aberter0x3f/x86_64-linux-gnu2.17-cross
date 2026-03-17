{
  stdenv,
  pkgsCross,
  fetchurl,
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
