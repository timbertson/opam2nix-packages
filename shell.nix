{ pkgs ? import <nixpkgs> {}, ci ? false}:
let
	upstream = pkgs.callPackage ./nix/default.nix {};
	base = (pkgs.nix-pin.api {}).callPackage ./nix/default.nix {};
	extraPackages = with pkgs;
		[ python gup base.opam2nixBin nix nix-pin ] ++ (
			if ci then [ nix-prefetch-scripts ] else []
		);
in
pkgs.stdenv.mkDerivation {
	name = "shell";
	buildInputs = extraPackages;
	passthru = base // { inherit upstream; };
}
