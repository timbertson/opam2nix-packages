
{ pkgs ? import <nixpkgs> {}}:
with pkgs;
let
	# For development, set OPAM2NIX_DEVEL to your local
	# opam2nix repo path
	devRepo = builtins.getEnv "OPAM2NIX_DEVEL";
	src = fetchgit {
  "url" = "https://github.com/timbertson/opam2nix-packages.git";
  "fetchSubmodules" = false;
  "sha256" = "1zja9miiacsscqwqvw2b350h4b8n5k6rlc90qh6gsh37mx8kbjvx";
  "rev" = "f62e640a046271cd8b9ef8f0713ccfe35f5c4da1";
};
	opam2nix = fetchgit {
  "url" = "https://github.com/timbertson/opam2nix.git";
  "fetchSubmodules" = false;
  "sha256" = "0yvms4cyy0nh5a4wxyyifbwimgbapsvny90bdw35l6fc1zlhragz";
  "rev" = "7c2ecb37a2e2f34417198112f0daedf17030c6d4";
};
in
if devRepo != "" then
	let toPath = s: /. + s; in
	callPackage "${devRepo}/nix" {} {
			src = toPath "${devRepo}/nix/local.tgz";
			opam2nix = toPath "${devRepo}/opam2nix/nix/local.tgz";
		}
else callPackage "${src}/nix" {} { inherit src opam2nix; }
