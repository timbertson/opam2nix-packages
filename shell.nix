{ pkgs ? import <nixpkgs> {}, ci ? false}:
let
	base = import ./nix/default.nix { inherit pkgs; };
	extraPackages = with pkgs;
		[ gup ] ++ (
			if ci then [ nix-prefetch-scripts ] else []
		);
in
pkgs.lib.overrideDerivation base (o: {
	nativeBuildInputs = o.nativeBuildInputs ++ extraPackages;
})
