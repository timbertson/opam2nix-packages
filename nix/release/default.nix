{ pkgs ? import <nixpkgs> {}}:
with pkgs;
let
		src = fetchFromGitHub {
			"owner" = "timbertson";
			"repo" = "opam2nix-packages";
			"sha256" = "071lxxsyjs7261jxwwgdha7rsp60gg3rw0kgr5hhfx3m28zmx6q8";
			"rev" = "3af26b4c3dab1d6355b66a848aa4e55c818dd428";
		};
		opam2nixSrc = fetchFromGitHub {
			"owner" = "timbertson";
			"repo" = "opam2nix";
			"sha256" = "1khq1b0c7ry8854nwl0qkfq0kddf4g49xmj1yp2bifk8kh2waqb7";
			"rev" = "version-0.3.1";
		};
		opam2nixBin = callPackage "${opam2nixSrc}/nix" {};
	in
	callPackage "${src}/nix" { inherit opam2nixBin; }

