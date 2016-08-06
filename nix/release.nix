
{ pkgs ? import <nixpkgs> {}}:
with pkgs;
let
	# For development, set OPAM2NIX_DEVEL to your local
	# opam2nix repo path
	devRepo = builtins.getEnv "OPAM2NIX_DEVEL";
	src = fetchgit {
  "url" = "https://github.com/timbertson/opam2nix-packages.git";
  "fetchSubmodules" = false;
  "sha256" = "1x0mcpsqsscfyc97bnzhzkx5s2y0ddkyv138z9xvn3w969d95mz5";
  "rev" = "7d1310e91d1fe48a8e21bdad8daca4e88814abfa";
};
	opam2nix = fetchgit {
  "url" = "https://github.com/timbertson/opam2nix.git";
  "fetchSubmodules" = false;
  "sha256" = "1swahnb3wvhd3xvphs4pqh1rz30d1h3nzpg5i3nwkcyd1af8b890";
  "rev" = "b2b554ef3e42cd367922d2ba910966a2ea2bbc98";
};
in
if devRepo != "" then
	let toPath = s: /. + s; in
	callPackage "${devRepo}/nix" {} {
			src = toPath "${devRepo}/nix/local.tgz";
			opam2nix = toPath "${devRepo}/opam2nix/nix/local.tgz";
		}
else callPackage "${src}/nix" {} { inherit src opam2nix; }
