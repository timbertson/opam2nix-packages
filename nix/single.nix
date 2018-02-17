{ pkg }:
let pkgs = import <nixpkgs> {}; in
(import ./local.nix {}).buildPackage pkg {
	ocamlAttr = "ocaml-ng.ocamlPackages_4_05.ocaml";
}
