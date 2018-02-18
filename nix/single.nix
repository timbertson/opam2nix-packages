{ pkg, shell ? null }:
let
	pkgs = import <nixpkgs> {};
	pkgSet = (import ./local.nix {}).buildPackageSet {
		packages = pkg;
		ocamlAttr = "ocaml-ng.ocamlPackages_4_05.ocaml";
	};
	pkgAttr = if shell == null then pkg else shell;
in
	builtins.getAttr pkgAttr pkgSet
