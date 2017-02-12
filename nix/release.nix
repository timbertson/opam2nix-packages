
{ pkgs ? import <nixpkgs> {}}:
with pkgs;
let
	# For development, set OPAM2NIX_DEVEL to your local
	# opam2nix repo path
	devRepo = builtins.getEnv "OPAM2NIX_DEVEL";
	src = fetchgit 	{
		"url" = "https://github.com/timbertson/opam2nix-packages.git";
		"fetchSubmodules" = false;
		"sha256" = "10j26624wncpf64p36wanv2rmg2dz3jxflaia4kdwn6dbwqlfjix";
		"rev" = "49ed0efecb9c9041ba01cbb66304a0e83d0e66e1";
	};
	opam2nix = fetchgit 	{
		"url" = "https://github.com/timbertson/opam2nix.git";
		"fetchSubmodules" = false;
		"sha256" = "0gxb5xx4sv8742r82z9svnbbljwjpjr6vygl9h95vahqvi3rb2zq";
		"rev" = "085de1003ac3f6f163a7f17b9f972afc4398db7d";
	};
in
if devRepo != "" then
	let toPath = s: /. + s; in
	callPackage "${devRepo}/nix" {} {
		src = toPath "${devRepo}/nix/local.tgz";
		opam2nix = toPath "${devRepo}/opam2nix/nix/local.tgz";
	}
else callPackage "${src}/nix" {} { inherit src opam2nix; }
