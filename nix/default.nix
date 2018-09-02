{
	pkgs ? import <nixpkgs> {},
	opam2nixBin ? pkgs.callPackage "${(pkgs.nix-update-source.fetch ./release/src-opam2nix.json).src}/nix" {}
}:
with pkgs;
let
	defaultPkgs = pkgs;

	# to support IFD in release.nix/overlay.nix, we build from `../` if it's already a store path
	src = if lib.isStorePath ../. then ../. else (nix-update-source.fetch ./release/src.json).src;

	api = let

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
				cmd = ''env OCAMLRUNPARAM=b ${opam2nixBin}/bin/opam2nix select \
					--repo ${generatedPackages} \
					--dest "$out" \
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
		buildNixRepo = opamRepo: makeRepository {
			opamRepository = opamRepo;
		};

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
				packages = api.buildPackageSet opamAttrs;
				selection = api.selectionsFileLax opamAttrs;
			}
		;

		# Augment a set of generated packages. This builds a fixpoint on the generated
		# packages to apply customisations.
		filterWorldArgs = attrs: {
			pkgs = attrs.pkgs or null;
			overrides = attrs.select or null;
		};
		applyWorld = {
			select,
			pkgs ? null,
			overrides ? null,
		}:
			let
			noop = ({super, self}: {});
			finalPkgs = defaulted pkgs defaultPkgs;
			lib = finalPkgs.lib;
			fix = f: let result = f result; in result;
			extend = rattrs: f: self: let super = rattrs self; in super // f { inherit self super; };
			defaultOverrides = import ../repo/overrides;
			userOverrides = defaulted overrides noop;
			format_version = 2;

			# packages have structure <name>.<version> - we want to combine all versions across
			# repos without merging the derivation attributes of individual versions
			mergeTwoLevels = lib.recursiveUpdateUntil (parent: l: r: (lib.length parent) == 1);
			mergeOpamPackages = self:
				let
					invokeRepo = repo: (import repo) self;
					addRepo = acc: repo: mergeTwoLevels acc (invokeRepo repo);
				in
				lib.foldl addRepo {} self.repositories;
		in
			assert format_version == opam2nixBin.format_version;
			fix
			(extend
				(extend
					(extend
						(self: {
							pkgs = finalPkgs;
							opam2nix = opam2nixBin;
							opamPackages = mergeOpamPackages self;
						})
						select)
					defaultOverrides)
				userOverrides)
		;

		defaultOpam2nixBin = opam2nixBin;

		makeRepository = {
			opamRepository,
			opam2nixBin ? null,
			packages ? null,
			numVersions ? null,
			digestMap ? null,
			ignoreBroken ? null,
			unclean ? null,
			verbose ? null,
			offline ? null,
			dest ? null,
		}: with lib; (
			let
			finalDest = defaulted dest "$out";
			finalOpam2nixBin = defaulted opam2nixBin defaultOpam2nixBin;
			optionalArg = prefix: arg: if arg == null then [] else [prefix arg];
			flags = [
				"--src" opamRepository
				"--dest" finalDest
			]
				++ (optional (defaulted ignoreBroken false) "--ignore-broken")
				++ (optional (defaulted unclean false) "--unclean")
				++ (optional (defaulted verbose false) "--verbose")
				++ (optional (defaulted offline true) "--offline")
				++ (optionalArg "--num-versions" numVersions)
				++ (optionalArg "--digest-map" digestMap)
				++ map (p: "'${p}'") (defaulted packages ["*"])
			; in
			stdenv.mkDerivation rec {
				name = "opam2nix-generated-packages";
				shellHook = "if [ '$dest' == '$out' ]; then echo '$dest must be set in shell mode'; exit 1; fi\n" + buildCommand + "\nexit 0";
				buildCommand = ''
					mkdir -p "${finalDest}"
					echo "+ ${finalOpam2nixBin}/bin/opam2nix generate" ${concatStringsSep " " flags}
					${finalOpam2nixBin}/bin/opam2nix generate ${concatStringsSep " " flags}
				'';
			}
		);

		# The official set of generated packages, which used to live in ./repo.
		# The package selection is restricted to this exact set due to the need
		# for `digestMap` to be exhaustive, so this is strongly bound to this
		# exact checkout of `opam2nix-packages`
		defaultOpamRepository = (nix-update-source.fetch ./release/src-opam-repository.json).src;

		generateOfficialPackages = {
			opamRepository ? defaultOpamRepository,
			digestMap ? ../repo/digest.json,
			opam2nixBin ? null,
			dest ? null,
			unclean ? null,
			offline ? null,
			verbose ? null,
			packages ? null
		}: makeRepository {
			inherit opamRepository digestMap dest unclean packages opam2nixBin offline verbose;
			numVersions = "2.3.2";
			ignoreBroken = true;
		};

		generatedPackages = generateOfficialPackages { offline = true; };

	in {
		# low-level selecting & importing
		selectionsFile = selectStrict;
		selectionsFileLax = selectLax;
		importSelectionsFile = selection_file: world:
			(applyWorld ({
				inherit pkgs; # defaults, overrideable
				select = import selection_file;
			} // world)).selection;
		importSelectionsFileLax = selection_file: world:
			api.importSelectionsFile selection_file (filterWorldArgs world);

		inherit buildNixRepo packageNames toSpec toSpecs buildOpamPackages opam2nixBin;

		# used in build scripts
		_generateOfficialPackages = generateOfficialPackages;

		# get the implementation of each specified package in the selections.
		# Selections are the result of `build` (or importing the selection file)
		packagesOfSelections = specs: selections:
			map (name: builtins.getAttr name selections) (packageNames specs);

		# Select-and-import. Returns a selection object with attributes for each extant package
		buildPackageSet = args: (api.importSelectionsFileLax (selectLax args) args);

		# like just the attribute values from `buildPackageSet`, but also includes ocaml dependency
		build = { specs, ... }@args:
			let selections = (api.buildPackageSet args); in
			[selections.ocaml] ++ (api.packagesOfSelections specs selections);

		# Takes a single spec and only returns a single selected package matching that.
		buildPackageSpec = spec: args: builtins.getAttr spec.name (api.buildPackageSet ({ specs = [spec]; } // args));

		# Like `buildPackageSpec` but only returns the single selected package.
		buildPackage = name: api.buildPackageSpec { inherit name; };

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

		opamRepository = defaultOpamRepository;
		opamPackages =
			let
				opamPackages = import generatedPackages {};
				realVersion = v: v != "latest";
				make = attr:
					let
						buildArgs = { ocamlAttr = "ocaml-ng.${attr}.ocaml"; };
					in
					lib.mapAttrs (name: versionPackages:
						let versions = lib.filter realVersion (lib.attrNames versionPackages); in
						lib.extendDerivation true (
							lib.listToAttrs (map (version: {
								name = builtins.replaceStrings ["."] ["_"] version;
								value = api.buildPackageSpec { inherit name; constraint = "=${version}"; } buildArgs;
							}) versions)
						) (api.buildPackage name buildArgs)
					) opamPackages;
			in
			lib.extendDerivation true {
				"4_05" = make "ocamlPackages_4_05";
			} generatedPackages;
	};
in
api
