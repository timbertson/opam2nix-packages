{ pkgs ? import <nixpkgs> {}}:
with pkgs;
let
		src = fetchFromGitHub {
			"owner" = "timbertson";
			"repo" = "opam2nix-packages";
			"sha256" = "1p220dfqhwfp3v5b9y2qf7fvi4n2wargsdq5japr0slyiwqdp5f0";
			"rev" = "e83b3a41b8bd1f9cb37265ecdf1850928a7edcb1";
		};
		opam2nixSrc = fetchFromGitHub {
			"owner" = "timbertson";
			"repo" = "opam2nix";
			"sha256" = "0dlr0m25a6hi6yybg3my5vp1022gkvyjbyfpq28yqmd7iasg5wg5";
			"rev" = "version-0.4.2";
		};
		opam2nixBin = callPackage "${opam2nixSrc}/nix" {};
	in
	callPackage "${src}/nix" { inherit opam2nixBin; }

