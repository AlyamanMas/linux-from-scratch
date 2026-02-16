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
          runScript = "nu";
        }).env;
    };
}
