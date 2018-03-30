{ pkg, shell ? null }:
let
	pkgs = import <nixpkgs> {};
	pkgSet = (import ./local.nix {}).buildPackageSet {
		specs = [ { name = pkg; } ];
		ocamlAttr = "ocaml-ng.ocamlPackages_4_05.ocaml";
	};
	pkgAttr = if shell == null then pkg else shell;
in
	builtins.getAttr pkgAttr pkgSet
