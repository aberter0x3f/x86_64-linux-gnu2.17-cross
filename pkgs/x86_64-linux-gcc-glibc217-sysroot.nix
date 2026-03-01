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
  x86_64-linux-centos7-sysroot,
}:

let
  version = "15.2.0";
  targetTriple = "x86_64-unknown-linux-gnu";
in

stdenv.mkDerivation {
  pname = "x86_64-linux-gcc-glibc217-sysroot";
  inherit version;

  src = fetchurl {
    url = "https://ftpmirror.gnu.org/gcc/gcc-${version}/gcc-${version}.tar.xz";
    hash = "sha256-Q4/ZloJrDIJIWinaA6ctcdbjVBqD7HAt9Ccfb+Al0k4=";
  };

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
    "--with-sysroot=${x86_64-linux-centos7-sysroot}"
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
