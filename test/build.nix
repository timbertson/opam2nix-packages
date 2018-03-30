{ pkgs ? import <nixpkgs> {}, world }:
with pkgs;
let
	opam2nix = callPackage ../nix/local.nix {};
	deps = opam2nix.buildPackageSet world;
in
stdenv.mkDerivation {
	name="test";
	buildInputs = opam2nix.build world;
	passthru = deps;
	buildCommand = ''
		mkdir -p $out
		${
			lib.concatStringsSep "\n" (
				map (name: "ln -s ${builtins.getAttr name deps} $out/${name}") world.specs
			)
		}
	'';
}

