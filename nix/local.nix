{ pkgs ? import <nixpkgs> {} }:
import ./default.nix
	{ inherit pkgs; }
	{
		src = ./local.tgz;
		opam2nix = ../opam2nix/nix/local.tgz;
	}
