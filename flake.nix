{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };
  outputs =
    {
      nixpkgs,
      ...
    }:
    let
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      lfsMntDir = "/mnt/lfs";
      cpuCoreNumber = 16;
    in
    {
      devShells.x86_64-linux.default =
        (pkgs.buildFHSEnv {
          name = "env for lfs buildling";
          targetPkgs =
            pkgs: with pkgs; [
              bison
              gnum4
              binutils
              gcc
              perl
              python3
              texinfoInteractive
              gnumake
              patch
              mount
            ];
          runScript = /* bash */ ''
            sh -c "exec env -i HOME=$HOME \
              TERM=$TERM \
              PS1='\u:\w\$ ' \
              LFS=${lfsMntDir} \
              LC_ALL=POSIX \
              LFS_TGT=x86_64-lfs-linux-gnu \
              PATH=${lfsMntDir}/tools/bin:/usr/bin \
              CONFIG_SITE=${lfsMntDir}/usr/share/config.site \
              MAKEFLAGS=-j${toString cpuCoreNumber} \
              /usr/bin/bash --norc +h"
          '';
        }).env;
    };
}
