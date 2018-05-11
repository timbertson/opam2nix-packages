{ pkgs ? import <nixpkgs> {},
	opam2nix ? pkgs.callPackage ./default.nix {},
	pkg, shell ? null
}:
let
	pkgSet = opam2nix.buildPackageSet {
		specs = [ { name = pkg; } ];
		ocamlAttr = "ocaml-ng.ocamlPackages_4_05.ocaml";
	};
	pkgAttr = if shell == null then pkg else shell;
in
	builtins.getAttr pkgAttr pkgSet
