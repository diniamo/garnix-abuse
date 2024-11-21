{
  description = "The flake I use to abuse Garnix when I don't want to build random stuff.";

  inputs.nixpkgs.url = "nixpkgs/nixos-unstable";

  outputs = {nixpkgs, ...}: let
    pkgs = nixpkgs.legacyPackages.x86_64-linux;

    raylib = pkgs.callPackage ./raylib.nix {};
  in {
    packages.x86_64-linux = {
      raylib-web = raylib.override {stdenv = pkgs.emscriptenStdenv;};
    };
  };
}
