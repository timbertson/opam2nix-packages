{ pkgs ? import <nixpkgs> {}, opam2nixBin ? pkgs.callPackage ../opam2nix/nix/default.nix {}}:
with pkgs;
let

	# to support IFD in release.nix/overlay.nix, we build from `../` if it's already a store path
	src = if lib.isStorePath ../. then ../. else (nix-update-source.fetch ./src.json).src;

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

		normalizePackageArgs = {
			name, src,
			packageName ? null,
			version ? null,
			opamFile ? null
		}:
			let parsedName = builtins.parseDrvName name; in
			{
				inherit src;
				packageName = defaulted packageName parsedName.name;
				version = defaulted version parsedName.version;
				opamFileSh = defaulted opamFile "\"$(find . -maxdepth 1 -name 'opam' -o -name '*.opam')\"";
			};

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

		partitionAttrs = attrNames: attrs:
			with lib;
			[
				(filterAttrs (name: val: elem name attrNames) attrs) # named attrs
				(filterAttrs (name: val: !(elem name attrNames)) attrs) # other attrs
			];

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

		buildOpamRepo = { packageName, version, src, opamFileSh }:
			stdenv.mkDerivation {
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
					cp ${opamFileSh} "$dest/opam"
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

		buildOpamPackages = packages: drvAttrs:
			let
				normalizedPackages = map normalizePackageArgs packages;
				specOfPackage = { packageName, version, ... }: { name = packageName; constraint = "=" + version; };
				opamRepos = map buildOpamRepo normalizedPackages;

				opamAttrs = (drvAttrs // {
					specs = (drvAttrs.specs or []) ++ (map specOfPackage normalizedPackages);
					extraRepos = (drvAttrs.extraRepos or []) ++ opamRepos;
				});
			in
			{
				inherit opamRepos;
				packages = utils.buildPackageSet opamAttrs;
				selection = utils.selectionsFileLax opamAttrs;
			}
		;

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

		inherit buildNixRepo packageNames toSpec toSpecs buildOpamPackages;

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

		buildOpamPackage = attrs:
			with lib;
			let
				partitioned = partitionAttrs ["name" "src" "opamFile" "packageName" "version" ] attrs;
				packageAttrs = elemAt partitioned 0;
				drvAttrs = removeAttrs (elemAt partitioned 1) ["passthru"];
				result = buildOpamPackages [packageAttrs] drvAttrs;
				normalizedPackage = normalizePackageArgs packageAttrs;
				drv = builtins.getAttr normalizedPackage.packageName result.packages;
				passthru = {
					opam2nix = {
						inherit (result) packages selection;
						repo = elemAt result.opamRepos 0;
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
