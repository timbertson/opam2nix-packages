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
		setToplevelPath () {
			base="$(dirname "$(dirname ''${BASH_SOURCE[0]})")"
			export OCAML_TOPLEVEL_PATH="$base/lib/toplevel"
		}
		addEnvHooks "$targetOffset" setToplevelPath

		addOCamlPath () {
			if test -d "''$1/lib"; then
				export OCAMLPATH="''${OCAMLPATH}''${OCAMLPATH:+:}''$1/lib"

				if test -d "''$1/lib/stublibs"; then
					export CAML_LD_LIBRARY_PATH="''${CAML_LD_LIBRARY_PATH}''${CAML_LD_LIBRARY_PATH:+:}''$1/lib/stublibs"
				else
					export CAML_LD_LIBRARY_PATH="''${CAML_LD_LIBRARY_PATH}''${CAML_LD_LIBRARY_PATH:+:}''$1/lib"
				fi
			fi
			export OCAMLFIND_DESTDIR="''$out/lib/"
			mkdir -p "''$out/lib"
		}
		addEnvHooks "$targetOffset" addOCamlPath
	'';
}

