
self: super: with super; {
	opam2nix = let
		src = fetchgit {
			"url" = "https://github.com/timbertson/opam2nix-packages.git";
			"fetchSubmodules" = true;
			"sha256" = "0abgax1ha5qfzqhg8n8kvd5rgh2r3wi46qb623q4487jdznm163g";
			"rev" = "d5b4e4ff87ae4466d950c0ce85f0b8faaf815160";
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
	};
}
