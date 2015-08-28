# this file is a convenience for users of `opam2nix`, so they don't have to
# provide opam2nix and opamPackages manually
selection_file: args@{
	pkgs,
	opam2nix ? import ./opam2nix/nix/opam2nix.nix { inherit pkgs; },
	opamPackages ? pkgs.callPackage ./repo {},
	...
}:
pkgs.callPackage selection_file ({
	inherit opam2nix opamPackages;
} // args)
