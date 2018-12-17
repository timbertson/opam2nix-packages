world: def:
let
	ocaml_version = (builtins.parseDrvName world.opamSelection.ocaml.name).version;
in {
	patches = (def.patches or []) ++ [ ./install_topfind.patch ];
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
			if [[ $preBuildPhases != *findlibPreBuildAction* ]]; then
				export preBuildPhases="''${preBuildPhases:+$preBuildPhases }findlibPreBuildAction"
			fi
		}

		addEnvHooks "$targetOffset" findlibSetup
	'';
}

