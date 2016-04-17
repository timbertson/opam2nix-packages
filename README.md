<img src="http://gfxmonk.net/dist/status/project/opam2nix.png">

# opam2nix is experimental software

I'm hoping to make it stable and a future part of `nixpkgs`. But for now, it's just this code which might work sometimes, and will probably change a lot.

This repository contains prebuilt nix derivations, as well as specific overrides (in `repo/`) for certain packages which require it.

## Building:

    $ ./build.sh

Note that local changes are whatever `git` knows about - this includes uncommitted changes, but does not include new files that haven't been added to `git`.

## Usage:

This repo contains generated `.nix` expressions, as well as some overrides required for a bunch of packages which don't quite work out of the box.

To add packages, add them in `packages.repo` and rebuild.

To include these nix expressions in your own package, you can use the following `opam2nix-packages.nix` file. Fill in the git URLs and revisions with the latest commits (or a commit in your fork, if you need to make a fork).

    { pkgs ? import <nixpkgs> {}}:
    with pkgs;
    let
      src = fetchgit {
        fetchSubmodules = false;
        url = "https://github.com/gfxmonk/opam2nix-packages.git";
        rev = "...";
        sha256 = "...";
      };
    
      opam2nixSrc = fetchgit {
        url = "https://github.com/gfxmonk/opam2nix.git";
        rev = "...";
        sha256 = "...";
      };
    in
    callPackage "${src}/nix" {} { inherit src opam2nixSrc; }

This will import nix/default.nix  from the exact version of the repo that you specified. With this file, you can use it like so:

    let opam2nix = import ./opam2nix-packages.nix { inherit pkgs; };

    # for simply building one package, use:
    let someOpamPackage = opam2nix.buildPackage "someOpamPackage";

    # for more advanced usage, you can make a selections object
    # and build it separately:
    let selections_file = opam2nix.select {packages = names;};
    let deps = opam2nix.import selections_file {};
    # deps has a named attribute for each package (including dependencies). Use it
    # for `buildInputs` with:
    let buildInputs = with deps; [ pkg1 pkg2 ... ];

## Configuration

 - `opam2nix.select` takes an attribute set with the following properties:
    - `ocamlAttr`: defaults to "ocaml"
    - `ocamlVersion`: default is extracted from the derivaiton name of `pkgs.<ocamlAttr>`, should rarely need to be overriden
    - `basePackages`: defaults to `["base-unix" "base-bigarray" "base-threads"]`, which is hacky.
    - `packages`: string list of package names
    - `args`: extra list of string arguments to pass to the `opam2nix` tool (default `[]`)

 - `opam2nix.import selections_file` takes an attribute set with the following properties, all optinoal:
   - `pkgs`
   - `overrides`: function accepting a `world` argument and returning attributes to be overriden / added
   - `opam2nix`

 - `opam2nix.build` and `opam2nix.buildPackage <pkgname>` take an attribute set which is passed to both `select` and `import` (both functions take distinct arguments, so there should be no overlap).

# How is the repo generated?

You hopefully don't have to know in order to use this repo - the above instructions should be enough to use these packages without ever delving into the command line utility yourself, but here's how it works:

### Step 1: generate a set of `nix` package definitions based on an opam repository.

    $ opam2nix repo --src ~/.opam/repo/ocaml.org --dest <dest>/nix/packages --cache <dest>/cache '*@latest'

This traverses the repo, scans the packages you've selected, downloads sources that it hasn't cached, reads `opam` files for dependencies, and spits out a `.nix` file for each version of each package.

### Step 2: Implement manual overrides

The above step generates "pure" package definitions based only on the information in the `opam` repository. But in order to integrate cleanly with `nixpkgs`, some generated packages need to be modified. This is implemented as a nix expression which wraps the generated packages. You should probably start with the `repo/default.nix` and `repo/overrides` from the `opam2nix-packages` repo, and make any changes you need from there.

### Step 3: select exact versions of each dependency

The generated `.nix` files are pretty dumb - they know the difference between mandatory and optional dependencies, but that's about all. They rely on you giving them a valid set of dependencies which satisfy all versioning constraints, conflicts, etc. Conveniently, this is exactly what `opam`'s solver does - but instead of actually installing everything, let's just get it to create a `nix` expression of the packages it _would_ install:

    $ opam2nix select \
      --repo <dest>/nix \
      --dest <dest>/selection.nix
      --ocaml-version 4.01.0 \
      --ocaml-attr ocaml \
      --base-packages 'base-unix,base-bigarray,base-threads' \
      lwt

(TODO: don't make users specify ocaml version, attr & base packages explicitly)

You shouldn't modify this `selections.nix` file directly, as you'll regenerate it whenever your dependencies change.
Instead, you should call it from your main `.nix` file like so:

    { pkgs ? import <nixpkgs> {}}:
    let
      selection = pkgs.callPackage ./dest/selection.nix {
        # one day, both of these may be rolled into `nixpkgs`, making them optional:
        opam2nix = pkgs.callPackage /path/to/opam2nix/default.nix {};
        opamPackages = import ./<dest>/nix { inherit pkgs; };
      };
    in
    {
      name = "foo-bar";
      buildInputs = [ selection.lwt ];
      # ...
    }

