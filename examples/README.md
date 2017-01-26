The examples show some concrete uses of `opam2nix`, and should be buildable as long as you have a recent `nixpkgs`.

# Scenario 1. [opam-dependencies](./opam-dependencies)

This is when your dependencies are in OPAM (and possibly nix), but you just want to build some software in nix. This is fairly straightforward, you can just use `opam2nix` to provide some dependencies in an otherwise standard nix derivation.

# Scenario 2. [opam-library](./opam-library)

This is when you are developing a library to be published on OPAM, but you want to use `opam2nix` to develop / distribute it as well.

Note: this workflow is a little complex, and may change.

### Layout

Each example has:

 - default.nix: self-contained derivation which imports opam2nix and `<nixpkgs>` explicitly
 - nix/default.nix: a parameterised derivation as you might find in `nixpkgs` - i.e. all dependencies injected

The examples reference `./nix/release.nix`, which imports opam2nix and its packages directly from the most recent github release. You only need to copy this one file into your own repository in order to import the corresponding version of `opam2nix` and this repository.
