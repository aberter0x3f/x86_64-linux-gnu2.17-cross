{
  description = "Cross-compile toolchain for x86_64-unknown-linux-gnu with glibc 2.17";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs =
    { self, nixpkgs }:
    let
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
    in
    {
      packages = forAllSystems (
        system:
        let
          pkgs = import nixpkgs { inherit system; };

          x86_64-linux-centos7-sysroot = pkgs.callPackage ./pkgs/x86_64-linux-centos7-sysroot.nix { };

          x86_64-linux-gcc-glibc217-sysroot = pkgs.callPackage ./pkgs/x86_64-linux-gcc-glibc217-sysroot.nix {
            inherit x86_64-linux-centos7-sysroot;
          };

          x86_64-linux-clang-glibc217 = pkgs.callPackage ./pkgs/x86_64-linux-clang-glibc217.nix {
            inherit x86_64-linux-centos7-sysroot x86_64-linux-gcc-glibc217-sysroot;
            llvmPackages = pkgs.llvmPackages_21;
          };
        in
        {
          inherit x86_64-linux-centos7-sysroot x86_64-linux-gcc-glibc217-sysroot x86_64-linux-clang-glibc217;
          default = x86_64-linux-clang-glibc217;
        }
      );
    };
}
