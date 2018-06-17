{ pkgs ? import <nixpkgs> {}}:
with pkgs;
let
		src = fetchgit {
			"url" = "https://github.com/timbertson/opam2nix-packages.git";
			"fetchSubmodules" = true;
			"sha256" = "1xf8wy5zcaj81v7nr3wwrhr6qjz22k8c2grwwbb74q0py5yhxwj6";
			"rev" = "40db0c95aeaa63b60ccdb85cb63118fce27038af";
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

