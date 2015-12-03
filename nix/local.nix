{ pkgs ? import <nixpkgs> {} }:
import ./default.nix
	{ inherit pkgs; }
	{
		src = ./local.tgz;
		opam2nixImpl = pkgs.callPackage ../opam2nix/nix/local.nix {};
	}
