The examples show some concrete uses of `opam2nix`, and should be buildable as long as you have a recent `nixpkgs`.

# Scenario 1. [opam-dependencies](./opam-dependencies)

This is when your dependencies are in OPAM (and possibly nix), but you just want to build some software in nix. This is fairly straightforward, you can just use `opam2nix` to provide some dependencies in an otherwise standard nix derivation.

# Scenario 2. [opam-library](./opam-library)

This is when you are developing a library to be published on OPAM, but you want to use `opam2nix` to develop / distribute it as well.

## Using OPAM libraries as dependencies

If you build an OPAM library in scenario 2, you can add it as a dependency to other projects. Say the library's name is `newlib`.

If you're building your new project in scenario 1, modify `nix/default.nix` like so:
```nix
let
  newlib = import path/to/newlib;
in
stdenv.mkDerivation {
  # ...
	buildInputs = [newlib] ++ opam2nix.build {
    # Dependencies from the public OPAM repo here
	};
  # ...
}
```

If your new project is another OPAM library that you're building in scenario 2, modify `nix/default/nix` like this:
```nix
let
  newlib = import path/to/newlib;
in
opam2nix.buildOpamPackage rec {
  # ...
  extraPackages = [newlib];
  # ...
}
```

## Using unpublished libraries on Git

If you need to use the bleeding edge of a library, or a library on GitHub that hasn't yet been published to OPAM, you can! Say you want to use the current tip of [ocaml-vdom](https://github.com/LexiFi/ocaml-vdom). In scenario 1, modify `nix/default.nix` like this:

```nix
let
	ocaml-vdom = opam2nix.buildOpamPackage rec {
		version = "0.1";
		name = "ocaml-vdom-${version}";
		src = pkgs.fetchgit 	{
		  "url" = "https://github.com/LexiFi/ocaml-vdom";
		  "rev" = "c66b7c846804e1c8e15e7d540408c02266d91369";
		  "sha256" = "1mx7qvlnni2z2rfgbqnnh67kvy6d7gsz698pa9609pwp3p2xg6h1";
		};
		ocamlAttr = "ocaml_4_03";
	};
in
stdenv.mkDerivation {
  # ...
	buildInputs = [ocaml-vdom] ++ opam2nix.build {
    # Dependencies from the public OPAM repo here
	};
  # ...
}
```

In scenario 2, modify it like this:

```nix
let
	ocaml-vdom = opam2nix.buildOpamPackage rec {
    # Same as the example for scenario 1
	};
in
opam2nix.buildOpamPackage rec {
  # ...
  extraPackages = [ocaml-vdom];
  # ...
}
```

### Layout

Each example has:

 - default.nix: self-contained derivation which imports opam2nix and `<nixpkgs>` explicitly
 - nix/default.nix: a parameterised derivation as you might find in `nixpkgs` - i.e. all dependencies injected

The examples reference `./nix/release.nix`, which imports opam2nix and its packages directly from the most recent github release. You only need to copy this one file into your own repository in order to import the corresponding version of `opam2nix` and this repository.
