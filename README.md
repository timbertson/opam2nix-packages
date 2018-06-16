<img src="http://gfxmonk.net/dist/status/project/opam2nix.png">

# opam2nix is experimental software

I'm hoping to make it stable and a future part of `nixpkgs`. But for now, it's just this code which might work sometimes, and will probably change a lot. It's quite complex, and it's likely that some simpler patterns will make themselves obvious after some more extensive use.

## Important note on using in your own project:

Don't try to clone `opam2nix` as part of your own derivation. If you instead copy the current `nix/release/default.nix` into your own source code you can import _just that one file_ (using `pkgs.callPackage) and it'll in turn clone the relevant commit from this repository and bootstrap itself. If needed, you can replace in the git URLs or revisions with the latest commits (or a commit in your fork).

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
   - `overrides`: function accepting `{self, super}` arguments and returning attributes to be overriden / added

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
   - `passthru`: extra passthru attributes, optional
   - also accepts options accepted by either `selectionsFile` or `importSelectionsFile`

 - `opam2nix.buildOpamPackages`: build multiple opam packages from source, rather than from a repository. Takes two arguments:
   - first, a list of attrsets containing package attributes (meanings and defaults match those described in `buildOpamPackage`):
     - `src`
     - `name`
     - `packageName`: optional, defaults to the first component of `name`
     - `version`: optional, defaults to the second component of `name`
     - `opamFilename`: the opam file path within `src`
   - second, an attrset of additional options accepted by either `selectionsFile` or `importSelectionsFile`

## What gets cached, and what gets rebuilt?

The inputs that define whether a given package needs to be rebuilt are:

 - The exact version of the `opam2nix` tool used. This is used as part of the build step for every package, so that's unavoidable.
 - Any dependant package changes. This could either be a version change of it (or one of its transitive dependencies), or
   the availability / unavailability of an optional dependency in the selection.

Notably, an update to this repository itself will cause a new set of `nix` files to be generated (one per available package version), but if the version of the `opam2nix` tool has not changed, no package implementations will need to be rebuilt.

Currently regeneration of the packageset and the selection process are both lightweight (they produce a bunch of small files very quickly), but they are also extremely verbose. This is a holdover from the days where things failed a lot more often, and should be turned off by default in the future.

## Hacking

This repo contains generated `.nix` expressions, as well as some overrides required for a bunch of packages which don't quite work out of the box.

To add specific package versions, add them in `packages.repo` and rebuild.

# How does it all work?

You hopefully don't have to know in order to use this repo - the above instructions should be enough to use these packages without ever delving into the guts of it, but chances are something will break, or maybe you're just curious:

### Step 1: generate a set of `nix` package definitions based on an opam repository.

The inputs are:

 - opam2nix
 - a checkout of the official `opam-repository` git repo
 - a digest map

See `makeRepository` in `nix/default.nix` for the flags passed to `opam2nix generate`.

This traverses the repo and generates a nix expression for each version of each package. The mapping of opam digests to nix digests means we can produce a working nix derivation without actually downloading any sources.

During development or to perform updates, this derivation can be invoked as a shell, in order to download unknown sources, verify them and add them to the existing digest map. This is used in `gup repo/packages`.

### Step 2: Implement manual overrides

The above step generates "pure" package definitions based only on the information in the `opam` repository. But in order to integrate cleanly with `nixpkgs`, some generated packages need to be modified. This is implemented as a nix expression which wraps the generated packages. You should probably start with the `repo/default.nix` and `repo/overrides` from the `opam2nix-packages` repo, and make any changes you need from there.

### Step 2: select exact versions of each dependency

The generated `.nix` files are pretty dumb - they know the difference between mandatory and optional dependencies, but that's about all. They rely on you giving them a valid set of dependencies which satisfy all versioning constraints, conflicts, etc. Conveniently, this is exactly what `opam`'s solver does - but instead of actually installing everything, let's just get it to create a `nix` expression of the packages it _would_ install.

This is done by `selectStrict` in `nix/default.nix`, and uses `opam2nix select`.

### Step 3: Build the world

We have the pure packages, generated from the upstream repo. We also have the selections, which picks the appropriate version of each necessary package.

Since nothing is perfect, we also have a number of hooks so we can modify packages, add additional repos, etc. This set of customizations is imaginatively called the "world", and is built from the arguments you pass to `buildPackage`, etc (described above). This is implemented as a fixpoint in `applyWorld` (in `nix/default.nix`), melding the generated package set, all customizations (including the builtin ones in `./repo/overrides`), plus the selections.

The building of individual package versions is also done by `opam2nix` - instead of trying to convert the build phase of each package into a shell script, we run `opam2nix invoke {configure|build}`, and pass it (via the environment) a JSON document describing the context of this package - where the `opam` file is, which of its optional dependencies are installed (and where), etc. This uses the opam API to execute the appropriate build actions directly.

