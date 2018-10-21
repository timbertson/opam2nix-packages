{ pkgs ? import <nixpkgs> {}}:
with pkgs;
let
		src = fetchFromGitHub {
			"owner" = "timbertson";
			"repo" = "opam2nix-packages";
			"sha256" = "0rajh0a986yvd4h0svwjb71ylyi4lj7b96bkqn85d1wmbs55gj2h";
			"rev" = "93558942398ad17b1665e04cb8a8af18b8e64b9d";
		};
		opam2nixSrc = fetchFromGitHub {
			"owner" = "timbertson";
			"repo" = "opam2nix";
			"sha256" = "0jjbi7v93yw6s6187nwcfk93s1vs9haaxppihy7ggqaj2rvziknj";
			"rev" = "version-0.4.3";
		};
		opam2nixBin = callPackage "${opam2nixSrc}/nix" {};
	in
	callPackage "${src}/nix" { inherit opam2nixBin; }

