world: def:
{
	buildPhase = ''
		${world.opam2nix}/bin/opam2nix invoke prebuild
		echo 'ldconf="ignore"' >> findlib.conf.in
		./configure \
			-bindir $out/bin \
			-mandir $out/share/man \
			-sitelib $out/lib \
			-config $out/etc/findlib.conf \
			-no-custom \
		;
		sed -i -e '/INSTALL_TOPFIND/ s/OCAML_CORE_STDLIB/OCAML_SITELIB/' src/findlib/Makefile
		make all
		make opt
		make install
	'';

	setupHook = world.pkgs.writeText "setupHook.sh" ''
		findlibPreBuildAction () {
			mkdir -p "''$out/lib"
		}

		findlibSetup () {
			base="$(dirname "$(dirname ''${BASH_SOURCE[0]})")"
			export OCAML_TOPLEVEL_PATH="$base/lib/toplevel"
			export OCAMLFIND_DESTDIR="''$out/lib/"
			if [[ ''${preBuildPhases:-} != *findlibPreBuildAction* ]]; then
				export preBuildPhases="''${preBuildPhases:+$preBuildPhases }findlibPreBuildAction"
			fi
		}

		addEnvHooks "$targetOffset" findlibSetup
	'';
}

