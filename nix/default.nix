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
	utils = {
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
			runCommand "opam-selection.nix" {} ''
				${impl}/bin/opam2nix-select --dest "$out" \
					--ocaml-version ${ocamlVersion} \
					--ocaml-attr ${ocamlAttr} \
					--base-packages ${concatStringsSep "," basePackages} \
					${concatStringsSep " " args} \
					${concatStringsSep " " packages} \
					;
			'';
		"import" = selection_file: world:
			assert opam2nix.format_version == 1; (import repository ({
				inherit pkgs opam2nix; # default, overrideable
				select = (import selection_file);
				format_version = import ../repo/format_version.nix;
			} // world)).opamSelection;
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
		passthru = utils // { formatVersion = 1; };
	};
in
impl
