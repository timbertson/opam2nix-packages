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

		flattenSingleSpec = attrMapper: obj: if builtins.isString obj
			then [obj] # plain string
			else lib.mapAttrsToList attrMapper obj;

		flattenSpecs = attrMapper: specs: if builtins.isList specs
			then lib.concatMap (flattenSingleSpec attrMapper) specs
			else (flattenSingleSpec attrMapper) specs;

		specOfVersionPair = name: spec: assert spec != null; assert name != null; if spec == true then name else
			if lib.any (pfx: lib.hasPrefix pfx spec) ["!" "<" "=" ">"]
				then "'${name}${spec}'" # includes relop
				else "'${name}=${spec}'"; # no relop, assume exact version
		packageSpecs = flattenSpecs specOfVersionPair;

		packageNameOfVersionPair = name: spec: name;
		packageNames = flattenSpecs packageNameOfVersionPair;

		to_s = obj:
			builtins.typeOf obj;
			# if obj == null then "null" else
			# if builtins.isString obj then obj else
			# if builtins.isList obj then "LIST" else
			# if builtins.isList obj then concatMap ", " (map to_s obj) else
			# "Unknown type";

	in {
		# Provide nix functions for selecting & importing,
		# rather than making users go via the command line.
		# As a bonus, we can derive a few of the tedious arguments
		# automatically when you go via nix.
		select = {
			ocamlAttr ? "ocaml",
			ocamlVersion ? with builtins; (parseDrvName (getAttr ocamlAttr pkgs).name).version,
			basePackages ? ["base-unix" "base-bigarray" "base-threads"], #XXX this is a hack.
			packages, args ? []
		}:
			with lib;
			# possible format for "specs":
			# list of strings
			# object with key = pkgname, attr = versionSpec, or
			# list with intermixed strings / objects
			let
			in
			runCommand "opam-selection.nix" {} ''
			env OCAMLRUNPARAM=b ${impl}/bin/opam2nix-select --dest "$out" \
				--ocaml-version ${ocamlVersion} \
				--ocaml-attr ${ocamlAttr} \
				--base-packages ${concatStringsSep "," basePackages} \
				${concatStringsSep " " args} \
				${concatStringsSep " " (packageSpecs packages)} \
			;
			'';
		"import" = selection_file: world:
			assert opam2nix.format_version == 1; let result = (import repository ({
				inherit pkgs opam2nix; # default, overrideable
				ocamlVersion = with builtins; (parseDrvName result.opamSelection.ocaml.name).version;
				select = (import selection_file);
				format_version = import ../repo/format_version.nix;
			} // world)); in result.opamSelection;
		packageNames = specs: packageNames specs;
		directDependencies = specs: selections: (map (name: builtins.getAttr name selections) (packageNames specs));
		build = { packages, ... }@args: (utils.import (utils.select args) args);
		buildPackage = name: args: builtins.getAttr name (utils.build ({ packages = [name]; } // args));
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
