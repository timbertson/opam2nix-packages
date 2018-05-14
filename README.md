<img src="http://gfxmonk.net/dist/status/project/opam2nix.png">

# opam2nix is experimental software

I'm hoping to make it stable and a future part of `nixpkgs`. But for now, it's just this code which might work sometimes, and will probably change a lot. It's quite complex, and it's likely that some simpler patterns will make themselves obvious after some more extensive use.

## Important note on using in your own project:

Don't try to clone `opam2nix` as part of your own derivation. If you instead copy the current `nix/release.nix` into your own source code you can import _just that one file_ (unsing `pkgs.callPackage) and it'll in turn clone the relevant commit from this repository and bootstrap itself. If needed, you can replace in the git URLs or revisions with the latest commits (or a commit in your fork).

Alternatively, you can copy `nix/overlay.nix` into `~/.config/nixpkgs/overlays` to make `opam2nix` available at the toplevel of your nixpkgs installation.

## Getting started:

The easiest way to get started is to check out the [examples/](./examples/) directory. It's got small, working examples that you can probably adapt to your own use very easily.

## Detailed usage instructions:

One you've copied `release.nix` as `opam2nix-packages.nix`, you can use it like so:

    let
      opam2nix = pkgs.callPackage ./opam2nix-packages.nix {};
    in

    # for simply building one package, use:
    opam2nix.buildPackage "someOpamPackage";

    # for non-opam software, you'll build selections based on direct dependencies,
    # and include each direct dependency in your `buildInputs`. This will
    # include the `ocaml` dependency:
    mkDerivation {
      buildInputs = opam2nix.build {
        specs = [
          { name = "lwt"; }
          { name = "irmin"; constraint = "=1.3.2"; }
        ];
      };
      ( ... )
    };

    # If you are developing your own package with an .opam file, you can save yourself the
    # trouble of replicating your dependencies in `nix`-land by using the `buildOpamPackage` function
    # instead of `mkDerivation`:
    opam2nix.buildOpamPackage rec {
      name = "pkgname-version";
      src = ( ... );
    };

The utility `buildPackageSet` is very useful for re-exposing all transitive ocaml dependencies for debugging purposes:

    passThru.ocamlPackages = opam2nix.buildPackageSet { packages = [ { name = "lwt"; } ]' };

This can be used with e.g. `nix-build -A ocamlPackages.lwt default.nix` if you need to build an individual dependency (but in your project's configuration; i.e. taking all optional dependencies and constraints into account). It accepts all the same arguments as `build` and produces an object with keys for every transitive dependency, rather than a list of direct dependencies.

The `build`, `buildPackageSet` and `buildOpamPackage` functions all accept the union of options
accepted by the lower level `selectionsFile` and `importSelectionsFile` functions (see "Configuration" section).

## Configuration

 - `opam2nix.selectionsFile` takes an attribute set with the following properties:
    - `ocamlAttr`: defaults to "ocaml"
    - `ocamlVersion`: default is extracted from the derivaiton name of `pkgs.<ocamlAttr>`, should rarely need to be overriden
    - `basePackages`: defaults to `["base-unix" "base-bigarray" "base-threads"]`, which is hacky.
    - `specs`: list of records with a name and optional constraint field.
    - `args`: extra list of string arguments to pass to the `opam2nix` tool (default `[]`)
    - `extraRepos`: extra list of opem repos (directories) to include

 - `opam2nix.importSelectionsFile selections_file` takes an attribute set with the following properties, all optional:
   - `pkgs`: defaults to the `pkgs` set opam2nix was imported with
   - `overrides`: function accepting a `world` argument and returning attributes to be overriden / added
   - `extraRepos`: as passed to `selectionsFile`
   - `opam2nix`: override the the opam2nix binary used for invoking build / install steps of packages

 - `opam2nix.buildPackageSet`: returns an attrset with an attribute for each selected package
   - accepts any option accepted by either `selectionsFile` or `importSelectionsFile`

 - `opam2nix.build`: returns a list of all selected packages (plus ocaml)
   - accepts any option accepted by either `selectionsFile` or `importSelectionsFile`

 - `opam2nix.buildPackageSpec`: build and import a package (by spec)
   - accepts two arguments - a single spec and a set of `buildPackageSet` options

 - `opam2nix.buildPackage`: build and import a package (by name)
   - accepts two arguments - a single package name and a set of `buildPackageSet` options

 - `opam2nix.buildOpamPackage`: build an opam package from source, rather than from a repository
   - `src`
   - `name`
   - `packageName`: optional, defaults to the first component of `name`
   - `version`: optional, defaults to the second component of `name`
   - `opamFilename`: the opam file path within `src`
   - also accepts options accepted by either `selectionsFile` or `importSelectionsFile`

 - `opam2nix.buildOpamPackages`: build a package set with many an opam packages
   from source, rather than from all from a repository
   - `packagesParsed` a list of (most) of the arguments accepted by `opam2nix.buildOpamPackage`
     - `src`
     - `packageName`: the name of OPAM package
     - `version`: the version of the OPAM package
     - `opamFilename`: the opam file path within `src`
   - also accepts options accepted by either `selectionsFile` or `importSelectionsFile`

## Hacking

This repo contains generated `.nix` expressions, as well as some overrides required for a bunch of packages which don't quite work out of the box.

To add specific package versions, add them in `packages.repo` and rebuild.

# Manual operation / how does it all work?

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
