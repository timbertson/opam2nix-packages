{ pkgs ? import <nixpkgs> {} }:
{ src, opam2nix ? null, opam2nixImpl ? null }:
with pkgs;
let _opam2nix = opam2nix; in
let
	makeDirectory = name: src: runCommand name {} ''
		if [ ! -e "${src}" ]; then
			echo "Error: ${src} does not exist"
			echo "  (Note: if you passed in a `src` attribute which doesn't"
			echo "  contain a nested opam2nix directory, you need to provide"
			echo "  an explicit `opam2nix` argument too)"
			exit 1
		fi
		if [ -f "${src}" ]; then
			mkdir "$out"
			tar xaf ${src} -C "$out" --strip-components=1;
		else
			ln -s "${src}" "$out"
		fi
	'';

	srcDir = makeDirectory "opam2nix-packages-src" src;
	opam2nix = let
		buildFromSrc = src: pkgs.callPackage "${src}/nix" {} { inherit src; };
	in
		if opam2nixImpl != null
			then opam2nixImpl
			else if _opam2nix != null
				then buildFromSrc (makeDirectory "opam2nix-src" _opam2nix)
				else buildFromSrc "${src}/opam2nix";

	repository = stdenv.mkDerivation {
		name = "opam2nix-repo";
		buildCommand = ''
			ln -s ${srcDir}/repo $out
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

		# get a list of package names from a specification collection
		specNames = map ({ name, ... }: name);

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
			assert opam2nix.format_version == 1; let result = (import repository ({
				inherit pkgs opam2nix; # default, overrideable
				ocamlVersion = parseOcamlVersion result.opamSelection.ocaml;
				select = (import selection_file);
				format_version = import ../repo/format_version.nix;
			} // world // {
				extraPackages = (world.extraPackages or [])
					++ map (path: import (buildNixRepo path)) (world.extraRepos or []);
			})); in result.opamSelection;

		inherit buildNixRepo specNames;

		# get the implementation of each specified package in the selections.
		# Selections are the result of `build` (or importing the selection file)
		packagesOfSelections = specs: selections:
			map (name: builtins.getAttr name selections) (specNames specs);

		# Select-and-import. Returns a selection object with attributes for each extant package
		buildPackageSet = { specs, ... }@args: (utils.importSelectionsFile (selectLax args) args);

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
				drvAttrs = removeAttrs attrs ["src" "opamFile" "packageName" "version" "passthru" "extraPackages" ];
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
		name = "opam2nix-packages-${lib.removeSuffix "\n" (builtins.readFile ../VERSION)}";
		buildCommand = ''
			mkdir -p $out/bin
			ln -s ${opam2nix}/bin/opam2nix $out/bin/
			ln -s ${repository} $out/repo
			cat > $out/bin/opam2nix-select <<EOF
#!${bash}/bin/bash
			set -eu
			$out/bin/opam2nix select --repo $out/repo \$@
EOF
			chmod +x $out/bin/opam2nix-select
		'';

		buildInputs = [ opam2nix ];
		passthru = utils // {
			formatVersion = 1;
			inherit opam2nix;
		};
	};
in
impl
