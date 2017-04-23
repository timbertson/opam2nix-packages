
{ pkgs ? import <nixpkgs> {}}:
with pkgs;
let
	# For development, set OPAM2NIX_DEVEL to your local
	# opam2nix repo path
	devRepo = builtins.getEnv "OPAM2NIX_DEVEL";
	src = fetchgit 	{
		"url" = "https://github.com/timbertson/opam2nix-packages.git";
		"fetchSubmodules" = false;
		"sha256" = "1nlrfi9j6mgbf2jgv7wk3pjf6cjp5lb6c5d8b2z2jib7mg8blwgq";
		"rev" = "4f57ba0ef0551886685e3a2c55e2213b2d0d9d8e";
	};
	opam2nix = fetchgit 	{
		"url" = "https://github.com/timbertson/opam2nix.git";
		"fetchSubmodules" = false;
		"sha256" = "00j2x5fgnhll12vkg9kygmnwh7y7b1dp5k8j2r46iq3zikgsv7q3";
		"rev" = "ac4212702eac44c3f15714d550f5d36487104a5a";
	};
in
if devRepo != "" then
	let toPath = s: /. + s; in
	callPackage "${devRepo}/nix" {} {
		src = toPath "${devRepo}/nix/local.tgz";
		opam2nix = let devSrc = "${devRepo}/opam2nix/nix/local.tgz"; in
			if builtins.pathExists devSrc then toPath devSrc else opam2nix;
	}
else callPackage "${src}/nix" {} { inherit src opam2nix; }
