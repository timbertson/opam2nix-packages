{ pkgs ? import <nixpkgs> {}}:
with pkgs;
let
		src = fetchFromGitHub {
			"owner" = "timbertson";
			"repo" = "opam2nix-packages";
			"sha256" = "1qlff36xri8f1b5plsimy2wzyvgqjgrymikjhhnky7kdxfq6pgm2";
			"rev" = "c7ed2a481a779045fd312b8956a0a6a842c12082";
		};
		opam2nixSrc = fetchFromGitHub {
			"owner" = "timbertson";
			"repo" = "opam2nix";
			"sha256" = "0ybagy69qcqz3fdwip34s3dx5h8glhbws3415s3d220mhslvjrs8";
			"rev" = "version-0.3.3";
		};
		opam2nixBin = callPackage "${opam2nixSrc}/nix" {};
	in
	callPackage "${src}/nix" { inherit opam2nixBin; }

