{ pkgs ? import <nixpkgs> {}}:
with pkgs;
let
		src = fetchgit {
			"url" = "https://github.com/timbertson/opam2nix-packages.git";
			"fetchSubmodules" = false;
			"sha256" = "0awmvzfswz4s06qcwbl1ff1ndz4dfkkdpis2w2mzsknb8qy4dapv";
			"rev" = "75319dcfc253d76c95599252ebc015cacb96556d";
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

