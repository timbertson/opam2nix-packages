{ pkgs ? import <nixpkgs> {} }:
{ src ? null, opam2nix ? null }:
with pkgs;
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

	_src = if src == null then ./local.tgz else src;
	_opam2nix = if opam2nix == null then
		(if src == null then ../opam2nix/nix/local.tgz else "${srcDir}/opam2nix")
		else opam2nix;

	srcDir = makeDirectory "opam2nix-packages-src" _src;
	repository = stdenv.mkDerivation {
		name = "opam2nix-repo";
		buildCommand = ''
			mkdir $out
			cd $out
			ln -s ${srcDir}/repo/packages
			for f in ${opam2nixDir}/src/nix/*; do
				ln -s "$f"
			done
		'';
	};
	opam2nixDir = makeDirectory "opam2nix" _opam2nix;
	opam2nixImpl = callPackage "${opam2nixDir}/nix" { src = _opam2nix; };
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
		"import" = let parentPkgs = pkgs; in selection_file: args@{
				pkgs ? parentPkgs,
				opamPackages ? pkgs.callPackage repository {},
				...
			}:
			pkgs.callPackage selection_file ({
				opam2nix = opam2nixImpl;
				inherit opamPackages;
			} // args);
		build = { packages, ... }@args: (utils.import (utils.select args) {});
		buildPackage = name: utils.build { package = name; };
	};

	impl = stdenv.mkDerivation {
		name = "opam2nix-packages";
		buildCommand = ''
			mkdir -p $out/bin
			ln -s ${opam2nixImpl}/bin/opam2nix $out/bin/
			ln -s ${repository} $out/repo
			cat > $out/bin/opam2nix-select <<EOF
#!${bash}/bin/bash
			set -eu
			$out/bin/opam2nix select --repo $out/repo \$@
EOF
			chmod +x $out/bin/opam2nix-select
		'';

		passthru = utils;
	};
in
impl
