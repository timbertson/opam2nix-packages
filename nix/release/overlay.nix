self: super: with super; {
	opam2nix = let
		src = fetchgit {
			"url" = "https://github.com/timbertson/opam2nix-packages.git";
			"fetchSubmodules" = true;
			"sha256" = "1zv75x9qq4vnk0n22zrxsi65a9jdl7f18mgs8dvd08hcwjfwmpky";
			"rev" = "a1d14205cde429387186e73c8d764536687eb406";
		};
		opam2nixSrc = fetchgit {
			"url" = "https://github.com/timbertson/opam2nix.git";
			"fetchSubmodules" = true;
			"sha256" = "0fanhwa94n7l0y962k7pivffdrv5838hqq8byy279zzhzzszww0d";
			"rev" = "374bb8d3c9956c82cd38c3e327f0f999fa6b8754";
		};
	in
	callPackage "${src}/nix" {
		opam2nixBin = callPackage "${opam2nixSrc}/nix" {};
	};
}
