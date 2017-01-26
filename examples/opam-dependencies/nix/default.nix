# paramaterised derivation with dependencies injected (callPackage style)
{ pkgs, stdenv, opam2nix }:
stdenv.mkDerivation {
	name = "opam2nix-hello";
	src = ../.;
	buildInputs = opam2nix.build {
		packages = [ "ocamlbuild" "ocamlfind" "lwt" ];
		ocamlAttr = "ocaml_4_03";
	};
	buildPhase = ''
		ocamlbuild -use-ocamlfind hello.native
	'';
	installPhase = ''
		mkdir $out/bin
		cp --dereference hello.native $out/bin/hello
	'';
}
