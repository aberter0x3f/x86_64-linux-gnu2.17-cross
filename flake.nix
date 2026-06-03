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
  description = "Cross-compile toolchain for x86_64-unknown-linux-gnu2.17";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
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
