world: def:
let
	ocaml_version = (builtins.parseDrvName world.opamSelection.ocaml.name).version;
in {
	patches = [ ./ldconf.patch ./install_topfind.patch ];
	buildPhase = ''
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
		# if test ocaml-stub; then
		# 	mkdir $out/bin/ocaml-stub
		# 	cp ocaml-stub $out/bin/ocaml-stub/ocaml
		# fi

	setupHook = world.pkgs.writeText "setupHook.sh" ''
		setToplevelPath () {
			base="$(dirname "$(dirname ''${BASH_SOURCE[0]})")"
			export OCAML_TOPLEVEL_PATH="$base/lib/toplevel"
		}
		envHooks+=(setToplevelPath)

		addOCamlPath () {
			if test -d "''$1/lib"; then
					export OCAMLPATH="''${OCAMLPATH}''${OCAMLPATH:+:}''$1/lib"
			fi
			export OCAMLFIND_DESTDIR="''$out/lib/"
			mkdir -p "''$out/lib"
		}
		envHooks+=(addOCamlPath)
	'';
}

