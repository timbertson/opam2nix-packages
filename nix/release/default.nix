{ pkgs ? import <nixpkgs> {}}:
with pkgs;
let
		src = fetchFromGitHub {
			"owner" = "timbertson";
			"repo" = "opam2nix-packages";
			"sha256" = "0dxk1c8mmbajb4z1i1f4aqnck6rxfw0a8rpkp272cq7rkhxcjf6w";
			"rev" = "7961b0d255674aa414e52e73e1b7eb596bb343d9";
		};
		opam2nixSrc = fetchFromGitHub {
			"owner" = "timbertson";
			"repo" = "opam2nix";
			"sha256" = "07xvim1yq55pc16kp2v191larwy5hv1k0725i8f5nxqb2kayjf51";
			"rev" = "version-0.3.2";
		};
		opam2nixBin = callPackage "${opam2nixSrc}/nix" {};
	in
	callPackage "${src}/nix" { inherit opam2nixBin; }

