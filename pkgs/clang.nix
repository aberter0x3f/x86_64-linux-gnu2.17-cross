{
  lib,
  stdenvNoCC,
  makeWrapper,
  llvmPackages,
  centos7-sysroot,
  gcc-sysroot,
}:

let
  gccSysrootVersion = gcc-sysroot.version;
in
stdenvNoCC.mkDerivation {
  pname = "x86_64-unknown-linux-gnu2.17-clang";
  version = llvmPackages.clang-unwrapped.version;

  nativeBuildInputs = [ makeWrapper ];

  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin

    makeWrapper ${llvmPackages.clang-unwrapped}/bin/clang++ $out/bin/x86_64-unknown-linux-gnu2.17-clang++ \
      --add-flags "--target=x86_64-unknown-linux-gnu" \
      --add-flags "-fuse-ld=lld" \
      --add-flags "--sysroot=${centos7-sysroot}" \
      --add-flags "-isystem ${gcc-sysroot}/include/c++/${gccSysrootVersion}" \
      --add-flags "-isystem ${gcc-sysroot}/include/c++/${gccSysrootVersion}/x86_64-unknown-linux-gnu" \
      --add-flags "-isystem ${gcc-sysroot}/lib/gcc/x86_64-unknown-linux-gnu/${gccSysrootVersion}/include" \
      --add-flags "-L ${gcc-sysroot}/lib64" \
      --add-flags "-L ${gcc-sysroot}/lib/gcc/x86_64-unknown-linux-gnu/${gccSysrootVersion}" \
      --add-flags "-B ${gcc-sysroot}/lib/gcc/x86_64-unknown-linux-gnu/${gccSysrootVersion}" \
      --add-flags "-Wl,--rpath-link=${centos7-sysroot}/lib64" \
      --add-flags "-Wl,--rpath-link=${gcc-sysroot}/lib64" \
      --add-flags "-Wl,-dynamic-linker,/lib64/ld-linux-x86-64.so.2" \
      --prefix PATH : ${lib.makeBinPath [ llvmPackages.lld ]}

    makeWrapper ${llvmPackages.clang-unwrapped}/bin/clang $out/bin/x86_64-unknown-linux-gnu2.17-clang \
      --add-flags "--target=x86_64-unknown-linux-gnu" \
      --add-flags "-fuse-ld=lld" \
      --add-flags "--sysroot=${centos7-sysroot}" \
      --add-flags "-isystem ${gcc-sysroot}/lib/gcc/x86_64-unknown-linux-gnu/${gccSysrootVersion}/include" \
      --add-flags "-L ${gcc-sysroot}/lib64" \
      --add-flags "-L ${gcc-sysroot}/lib/gcc/x86_64-unknown-linux-gnu/${gccSysrootVersion}" \
      --add-flags "-B ${gcc-sysroot}/lib/gcc/x86_64-unknown-linux-gnu/${gccSysrootVersion}" \
      --add-flags "-Wl,--rpath-link=${centos7-sysroot}/lib64" \
      --add-flags "-Wl,--rpath-link=${gcc-sysroot}/lib64" \
      --add-flags "-Wl,-dynamic-linker,/lib64/ld-linux-x86-64.so.2" \
      --prefix PATH : ${lib.makeBinPath [ llvmPackages.lld ]}

    runHook postInstall
  '';

  meta = {
    mainProgram = "x86_64-unknown-linux-gnu2.17-clang";
  };
}
