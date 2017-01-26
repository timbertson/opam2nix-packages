
{ pkgs ? import <nixpkgs> {}}:
with pkgs;
let
	# For development, set OPAM2NIX_DEVEL to your local
	# opam2nix repo path
	devRepo = builtins.getEnv "OPAM2NIX_DEVEL";
	src = fetchgit 	{
		"url" = "https://github.com/timbertson/opam2nix-packages.git";
		"fetchSubmodules" = false;
		"sha256" = "0y1wc64xxqs053b7jixvnqs6is7l01m5cvdfsjph0na42i5vlwj1";
		"rev" = "d3ec4d1491702ca194fdc0655e9e919207b460d2";
	};
	opam2nix = fetchgit 	{
		"url" = "https://github.com/timbertson/opam2nix.git";
		"fetchSubmodules" = false;
		"sha256" = "0w13aabqwqvkrxvd98c2fpfran7si2rmqjym0lpdwns8mwghdw1v";
		"rev" = "aaa902104e1a98b6d907420549580537d1feee8e";
	};
in
if devRepo != "" then
	let toPath = s: /. + s; in
	callPackage "${devRepo}/nix" {} {
		src = toPath "${devRepo}/nix/local.tgz";
		opam2nix = toPath "${devRepo}/opam2nix/nix/local.tgz";
	}
else callPackage "${src}/nix" {} { inherit src opam2nix; }
