{ pkgs ? import <nixpkgs> {}, opam2nixBin ? pkgs.callPackage ../opam2nix/nix/default.nix {} }:
with pkgs;
let
	src = (nix-update-source.fetch ./src.json).src;

	repository = stdenv.mkDerivation {
		name = "opam2nix-repo";
		inherit src;
		installPhase = ''
			cp -r repo $out
		'';
	};
	utils = let

		## Specifications

		# A specification is attrset with a `name` field and optional `constraint`
		# field. Names and constraints are defined as in OPAM.
		#
		#   { name = "foo"; constraint = ">4.0.0"; }

		# Normalize a list of specs into a list of concatenated name+constraints
		specStrings = map ({ name, constraint ? "" }: "'${name}${constraint}'");

		# toSpec and toSpecs are utilities for allowing a shorthand string "x"
		# to stand for ({name = "x";})
		toSpec = obj: if builtins.isString obj
			then { name = obj; } # plain string
			else obj; # assume well-formed spec

		toSpecs = map toSpec;

		# get a list of package names from a specification collection
		packageNames = map ({ name, ... }: name);

		## Other stuff

		defaulted = value: dfl: if value == null then dfl else value;
		defaultOcamlAttr = "ocaml";
		configureOcamlImpl = ocamlAttr: let
				attr = defaulted ocamlAttr defaultOcamlAttr;
				attrPath = lib.splitString "." attr;
			in {
				impl = lib.getAttrFromPath attrPath pkgs;
				args = ["--ocaml-attr" attr];
			};
		parseOcamlVersion = { name, ... }: (builtins.parseDrvName name).version;

		defaultBasePackages = ["base-unix" "base-bigarray" "base-threads"]; #XXX this is a hack.
		defaultArgs = [];

		selectLax = {
			# used by `build`, so that you can combine import-time (world) options
			# with select-time options
			ocamlAttr ? null,
			ocaml ? null,
			ocamlVersion ? null,
			basePackages ? null,
			specs,
			extraRepos ? [],
			args ? defaultArgs,
			... # ignored
		}:
			with lib;
			let
				ocamlSpec = configureOcamlImpl ocamlAttr;
				extraRepoArgs = map (repo: "--repo \"${buildNixRepo repo}\"") extraRepos;
				ocamlVersionResolved = parseOcamlVersion ocamlSpec.impl;
				basePackagesResolved = defaulted basePackages defaultBasePackages;
				cmd = ''env OCAMLRUNPARAM=b ${impl}/bin/opam2nix-select --dest "$out" \
					--ocaml-version ${defaulted ocamlVersion ocamlVersionResolved} \
					--base-packages ${concatStringsSep "," basePackagesResolved} \
					${concatStringsSep " " ocamlSpec.args} \
					${concatStringsSep " " extraRepoArgs} \
					${concatStringsSep " " args} \
					${concatStringsSep " " (specStrings specs)} \
				;
				'';
			in
			# possible format for "specs":
			# list of strings
			# object with key = pkgname, attr = versionSpec, or
			# list with intermixed strings / objects
			runCommand "opam-selection.nix" {} ''
				echo + ${cmd}
				${cmd}
			'';

		# builds a nix repo from an opam repo. Doesn't allow for customisation like
		# overrides etc, but useful for adding non-upstreamed opam packages into the world
		buildNixRepo = opamRepo: runCommand "opam2nix-${opamRepo.name}" {} ''
			mkdir -p "$out/packages"
			env OCAMLRUNPARAM=b ${impl}/bin/opam2nix generate --src "${opamRepo}" --cache .cache --dest "$out/packages" '*'
			echo 'import ./packages' > "$out/default.nix"
		'';

		selectStrict = {
			# exposed as `select`, so you know if you're using an invalid argument
			ocamlAttr ? null,
			ocamlVersion ? null,
			ocaml ? null,
			basePackages ? null,
			specs,
			extraRepos ? [],
			args ? defaultArgs,
		}@conf: selectLax conf;

	in {
		# low-level selecting & importing
		selectionsFile = selectStrict;
		selectionsFileLax = selectLax;
		importSelectionsFile = selection_file: world:
			assert opam2nixBin.format_version == 1; let result = (import repository ({
				inherit pkgs; # defaults, overrideable
				opam2nix = opam2nixBin;
				ocamlVersion = parseOcamlVersion result.opamSelection.ocaml;
				select = (import selection_file);
				format_version = import ../repo/format_version.nix;
			} // world // {
				extraPackages = map (path: import (buildNixRepo path)) (world.extraRepos or []);
			})); in result.opamSelection;

		inherit buildNixRepo packageNames toSpec toSpecs;

		# get the implementation of each specified package in the selections.
		# Selections are the result of `build` (or importing the selection file)
		packagesOfSelections = specs: selections:
			map (name: builtins.getAttr name selections) (packageNames specs);

		# Select-and-import. Returns a selection object with attributes for each extant package
		buildPackageSet = args: (utils.importSelectionsFile (selectLax args) args);

		# like just the attribute values from `buildPackageSet`, but also includes ocaml dependency
		build = { specs, ... }@args:
			let selections = (utils.buildPackageSet args); in
			[selections.ocaml] ++ (utils.packagesOfSelections specs selections);

		# Takes a single spec and only returns a single selected package matching that.
		buildPackageSpec = spec: args: builtins.getAttr spec.name (utils.buildPackageSet ({ specs = [spec]; } // args));

		# Like `buildPackageSpec` but only returns the single selected package.
		buildPackage = name: buildPackageConstraint { inherit name; };

		# build a nix derivation from a (local) opam library, i.e. one not in the official repositories
		buildOpamPackage = attrs:
			let
				drvAttrs = removeAttrs attrs ["src" "opamFile" "packageName" "version" "passthru" ];
				parsedName = builtins.parseDrvName attrs.name;
				packageName = attrs.packageName or parsedName.name;
				version = attrs.version or parsedName.version;

				opamRepo = let
					opamFilename = attrs.opamFile or "\"$(find . -maxdepth 1 -name 'opam' -o -name '*.opam')\"";
					src = attrs.src;
					in stdenv.mkDerivation {
						name = "${packageName}-${version}-repo";
						inherit src;
						configurePhase = "true";
						buildPhase = "true";
						installPhase = ''
							if [ -z "${version}" ]; then
								echo "Error: no version specified"
								exit 1
							fi
							dest="$out/packages/${packageName}/${packageName}.${version}"
							mkdir -p "$dest"
							cp ${opamFilename} "$dest/opam"
							if ! [ -f "$dest/opam" ]; then
								echo "Error: opam file not created"
								exit 1
							fi
							if [ -f "${src}" ]; then
								echo 'archive: "${src}"' > "$dest/url"
							else
								echo 'local: "${src}"' > "$dest/url"
							fi
						'';
					};

				opamAttrs = (drvAttrs // {
					specs = (attrs.specs or []) ++ [ { name = packageName; constraint = "=" + version; } ];
					extraRepos = (attrs.extraRepos or []) ++ [ opamRepo ];
				});

				packageSet = utils.buildPackageSet opamAttrs;
				drv = builtins.getAttr packageName packageSet;
				passthru = {
					opam2nix = {
						repo = opamRepo;
						packages = packageSet;
						selection = utils.selectionsFileLax opamAttrs;
					};
				} // (attrs.passthru or {});
			in
			lib.extendDerivation true passthru drv;
	};

	impl = stdenv.mkDerivation {
		name = "opam2nix-packages-0.3";
		inherit src;
		buildCommand = ''
			mkdir -p $out/bin
			ln -s ${opam2nixBin}/bin/opam2nix $out/bin/
			ln -s ${repository} $out/repo
			cat > $out/bin/opam2nix-select <<EOF
#!${bash}/bin/bash
			set -eu
			$out/bin/opam2nix select --repo $out/repo \$@
EOF
			chmod +x $out/bin/opam2nix-select
		'';

		passthru = utils // {
			formatVersion = 1;
			inherit opam2nixBin;
		};
	};
in
impl
