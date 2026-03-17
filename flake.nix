{
  description = "Cross-compile toolchain for x86_64-unknown-linux-gnu2.17";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
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

          centos7-sysroot = pkgs.callPackage ./pkgs/centos7-sysroot.nix { };

          gcc-sysroot = pkgs.callPackage ./pkgs/gcc-sysroot.nix {
            inherit centos7-sysroot;
          };

          clang = pkgs.callPackage ./pkgs/clang.nix {
            inherit centos7-sysroot gcc-sysroot;
            llvmPackages = pkgs.llvmPackages_21;
          };
        in
        {
          inherit centos7-sysroot gcc-sysroot clang;
          default = clang;
        }
      );
    };
}
