# standalone derivation, for nix-build, nix-shell, etc
{ pkgs ? import <nixpkgs> {} }:
pkgs.callPackage ./nix {
	opam2nix = pkgs.callPackage ../../nix/release.nix {};
}
