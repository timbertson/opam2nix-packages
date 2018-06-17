self: super: with super; {
	opam2nix = let
		src = fetchgit {
			"url" = "https://github.com/timbertson/opam2nix-packages.git";
			"fetchSubmodules" = true;
			"sha256" = "07zg31c7m0cl4rcvr8ngs22ikvllwy43246gl4wvm70kqj6d10sn";
			"rev" = "b44450dabe3da132c6da959e8c19fe9a5ed7815e";
		};
		opam2nixSrc = fetchFromGitHub {
			"owner" = "timbertson";
			"repo" = "opam2nix";
			"sha256" = "1khq1b0c7ry8854nwl0qkfq0kddf4g49xmj1yp2bifk8kh2waqb7";
			"rev" = "version-0.3.1";
		};
		opam2nixBin = callPackage "${opam2nixSrc}/nix" {};
	in
	callPackage "${src}/nix" { inherit opam2nixBin; }
;
}
