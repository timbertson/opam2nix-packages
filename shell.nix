{ pkgs ? import <nixpkgs> {}}:
let
	base = import ./nix/local.nix { inherit pkgs; };
in
pkgs.lib.overrideDerivation base (o: {
	nativeBuildInputs = o.nativeBuildInputs ++ [pkgs.gup];
})
