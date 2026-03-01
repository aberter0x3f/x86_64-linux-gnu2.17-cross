{
  lib,
  stdenvNoCC,
  makeWrapper,
  llvmPackages,
  x86_64-linux-centos7-sysroot,
  x86_64-linux-gcc-glibc217-sysroot,
}:

let
  gccSysrootVersion = x86_64-linux-gcc-glibc217-sysroot.version;
in
stdenvNoCC.mkDerivation {
  pname = "x86_64-linux-clang-glibc217";
  version = llvmPackages.clang-unwrapped.version;

  nativeBuildInputs = [ makeWrapper ];

  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin

    makeWrapper ${llvmPackages.clang-unwrapped}/bin/clang++ $out/bin/x86_64-unknown-linux-gnu2.17-clang++ \
      --add-flags "--target=x86_64-unknown-linux-gnu" \
      --add-flags "-fuse-ld=lld" \
      --add-flags "--sysroot=${x86_64-linux-centos7-sysroot}" \
      --add-flags "-isystem ${x86_64-linux-gcc-glibc217-sysroot}/include/c++/${gccSysrootVersion}" \
      --add-flags "-isystem ${x86_64-linux-gcc-glibc217-sysroot}/include/c++/${gccSysrootVersion}/x86_64-unknown-linux-gnu" \
      --add-flags "-isystem ${x86_64-linux-gcc-glibc217-sysroot}/lib/gcc/x86_64-unknown-linux-gnu/${gccSysrootVersion}/include" \
      --add-flags "-L ${x86_64-linux-gcc-glibc217-sysroot}/lib64" \
      --add-flags "-L ${x86_64-linux-gcc-glibc217-sysroot}/lib/gcc/x86_64-unknown-linux-gnu/${gccSysrootVersion}" \
      --add-flags "-B ${x86_64-linux-gcc-glibc217-sysroot}/lib/gcc/x86_64-unknown-linux-gnu/${gccSysrootVersion}" \
      --add-flags "-Wl,--rpath-link=${x86_64-linux-centos7-sysroot}/lib64" \
      --add-flags "-Wl,--rpath-link=${x86_64-linux-gcc-glibc217-sysroot}/lib64" \
      --add-flags "-Wl,-dynamic-linker,/lib64/ld-linux-x86-64.so.2" \
      --prefix PATH : ${lib.makeBinPath [ llvmPackages.lld ]}

    makeWrapper ${llvmPackages.clang-unwrapped}/bin/clang $out/bin/x86_64-unknown-linux-gnu2.17-clang \
      --add-flags "--target=x86_64-unknown-linux-gnu" \
      --add-flags "-fuse-ld=lld" \
      --add-flags "--sysroot=${x86_64-linux-centos7-sysroot}" \
      --add-flags "-isystem ${x86_64-linux-gcc-glibc217-sysroot}/lib/gcc/x86_64-unknown-linux-gnu/${gccSysrootVersion}/include" \
      --add-flags "-L ${x86_64-linux-gcc-glibc217-sysroot}/lib64" \
      --add-flags "-L ${x86_64-linux-gcc-glibc217-sysroot}/lib/gcc/x86_64-unknown-linux-gnu/${gccSysrootVersion}" \
      --add-flags "-B ${x86_64-linux-gcc-glibc217-sysroot}/lib/gcc/x86_64-unknown-linux-gnu/${gccSysrootVersion}" \
      --add-flags "-Wl,--rpath-link=${x86_64-linux-centos7-sysroot}/lib64" \
      --add-flags "-Wl,--rpath-link=${x86_64-linux-gcc-glibc217-sysroot}/lib64" \
      --add-flags "-Wl,-dynamic-linker,/lib64/ld-linux-x86-64.so.2" \
      --prefix PATH : ${lib.makeBinPath [ llvmPackages.lld ]}

    runHook postInstall
  '';

  meta = {
    mainProgram = "x86_64-unknown-linux-gnu2.17-clang";
  };
}
