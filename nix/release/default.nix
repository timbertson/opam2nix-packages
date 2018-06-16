{ pkgs ? import <nixpkgs> {}}:
with pkgs;
let
		src = fetchgit {
			"url" = "https://github.com/timbertson/opam2nix-packages.git";
			"fetchSubmodules" = true;
			"sha256" = "0ai6p6rlryy1akasrn3jm7kqlv9x4d9sllg8byxkq8yv9aw068ag";
			"rev" = "13325c55b1f6a56bbb76dac9009aa25a6f54b4b9";
		};
		opam2nixSrc = fetchgit {
			"url" = "https://github.com/timbertson/opam2nix.git";
			"fetchSubmodules" = true;
			"sha256" = "0fanhwa94n7l0y962k7pivffdrv5838hqq8byy279zzhzzszww0d";
			"rev" = "79caf71f87d9b75b20a1f02ab91dec0c2f4e7555";
		};
	in
	callPackage "${src}/nix" {
		opam2nixBin = callPackage "${opam2nixSrc}/nix" {};
	}
