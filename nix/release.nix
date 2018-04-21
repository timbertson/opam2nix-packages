{ pkgs ? import <nixpkgs> {}}:
with pkgs;
let
		src = fetchgit {
			"url" = "https://github.com/timbertson/opam2nix-packages.git";
			"fetchSubmodules" = true;
			"sha256" = "17q31sm1g8yp9ax002nmmi07vmgkzarym0i3vljzhyp2nqb04dz7";
			"rev" = "d85a6ae2f1b5f4e09696bee2ba572b800b7076c1";
		};
		opam2nixSrc = fetchgit {
			"url" = "https://github.com/timbertson/opam2nix.git";
			"fetchSubmodules" = true;
			"sha256" = "03myq1yhcfi0dilzrm43gzyiy3pqxpl2ja0hw8wma5yzxf40hlhj";
			"rev" = "db3228a5c49c184530f11f65a20621567135c327";
		};
	in
	callPackage "${src}/nix" {
		opam2nixBin = callPackage "${opam2nixSrc}/nix" {};
	}
