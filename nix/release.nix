
{ pkgs ? import <nixpkgs> {}}:
with pkgs;
let
	# For development, set OPAM2NIX_DEVEL to your local
	# opam2nix repo path
	devRepo = builtins.getEnv "OPAM2NIX_DEVEL";
	src = fetchgit 	{
		"url" = "https://github.com/timbertson/opam2nix-packages.git";
		"fetchSubmodules" = false;
		"sha256" = "130px0sp9lq3isl02da3n0250gv5a0lbcqmyx36qn3d7y5xsijjr";
		"rev" = "8ca05d152980384a5b426e64b419eee2b9d9ba89";
	};
	opam2nix = fetchgit 	{
		"url" = "https://github.com/timbertson/opam2nix.git";
		"fetchSubmodules" = false;
		"sha256" = "0vf0k0y817fc8x9h1rg26ngvz3wyvwx600qh9p98dk3mai88cyga";
		"rev" = "96c8d83a3262917562b243ebb5d0a8da0c7335a3";
	};
in
if devRepo != "" then
	let toPath = s: /. + s; in
	callPackage "${devRepo}/nix" {} {
		src = toPath "${devRepo}/nix/local.tgz";
		opam2nix = toPath "${devRepo}/opam2nix/nix/local.tgz";
	}
else callPackage "${src}/nix" {} { inherit src opam2nix; }
