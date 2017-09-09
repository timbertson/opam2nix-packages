{self, super}:
with self.pkgs;
with lib;
let
	overrideAll = fn: versions: mapAttrs (version: def: lib.overrideDerivation def fn) versions;

	# XXX it's not really a `configure` phase, is it?
	addNcurses = def: overrideAll (impl: { nativeBuildInputs = impl.nativeBuildInputs ++ [ncurses]; }) def;
	disableStackProtection = def: overrideAll (impl: { hardeningDisable = [ "stackprotector" ]; }) def;
	opamPackages = super.opamPackages;
in
{
	opamPackages = super.opamPackages // {
		ocamlfind = overrideAll ((import ./ocamlfind) self) opamPackages.ocamlfind;

		camlp4 = overrideAll (impl: {
			# camlp4 uses +camlp4 directory, but when installed individually it's just
			# ../ocaml/camlp4
			configurePhase = ''
				find . -name META.in | while read f; do
					sed -i -e 's|"+|"../ocaml/|' "$f"
				done
				'';
		}) opamPackages.camlp4;

		js_of_ocaml = overrideAll (impl: {
			configurePhase = ''
				sed -i -e 's|-I +camlp4|-package camlp4|' lib/Makefile
			'';
		}) opamPackages.js_of_ocaml;

		cstruct = overrideAll (impl: {
			installPhase = "make install JS_DEST=$OCAMLFIND_DESTDIR";
		}) opamPackages.cstruct;

		gmp-xen = overrideAll (impl: {
			# this is a plain C lib
			configurePhase = "unset OCAMLFIND_DESTDIR";
		}) opamPackages.gmp-xen;

		lablgtk = overrideAll (impl: {
			nativeBuildInputs = impl.nativeBuildInputs ++ [ pkgconfig gtk2.dev ];
		}) opamPackages.lablgtk;

		lwt = overrideAll (impl: {
			nativeBuildInputs = impl.nativeBuildInputs ++ [ ncurses ];
			setupHook = writeText "setupHook.sh" ''
				export LD_LIBRARY_PATH="$(dirname "$(dirname ''${BASH_SOURCE[0]})")/lib/lwt''${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
			'';
		}) opamPackages.lwt;

		ctypes = overrideAll (impl: {
			nativeBuildInputs = impl.nativeBuildInputs ++ [ pkgconfig libffi ncurses ];
		}) opamPackages.ctypes;

		solo5-kernel-vertio = disableStackProtection opamPackages.solo5-kernel-vertio;
		solo5-kernel-ukvm = disableStackProtection opamPackages.solo5-kernel-ukvm;
		nocrypto = disableStackProtection opamPackages.nocrypto;

		zarith-xen = overrideAll (impl: {
			buildPhase = "${pkgs.bash}/bin/bash ${./zarith-xen/install.sh}";
			installPhase = "true";
		}) opamPackages.zarith-xen;

		"0install" = overrideAll (impl:
			# disable tests, beause they require additional setup
			{
				buildInputs = [ pkgs.makeWrapper ];
				configurePhase = ''
					# ZI makes it very difficult to opt out of tests
					sed -i -e 's|tests/test\.|__disabled_tests/test.|' ocaml/Makefile
				'';
				preFixup = ''
					wrapProgram $out/bin/0install \
						--prefix PATH : "${pkgs.gnupg}/bin"
				'';
			}
		) opamPackages."0install";

		# fallout of https://github.com/ocaml/opam-repository/pull/6657
		omake = addNcurses opamPackages.omake;
	};
}
