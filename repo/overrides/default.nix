{self, super}:
with self.pkgs;
with lib;
let
	overrideAll = fn: versions: mapAttrs (version: def: lib.overrideDerivation def fn) versions;
	addPatches = patches: orig: { patches = (orig.patches or []) ++ patches; };
	patchAll = patches: overrideAll (addPatches patches);
	overrideIf = predicate: fn: versions:
		mapAttrs (version: def:
			if predicate version then
				lib.overrideDerivation def fn
			else def
		) versions;

	# XXX it's not really a `configure` phase, is it?
	addNcurses = def: overrideAll (impl: { nativeBuildInputs = impl.nativeBuildInputs ++ [ncurses]; }) def;
	disableStackProtection = def: overrideAll (impl: { hardeningDisable = [ "stackprotector" ]; }) def;
	opamPackages = super.opamPackages;
in
{
	ocaml = self.pkgs.callPackage ./ocaml.nix {} super.ocaml;
	opamPackages = super.opamPackages // {
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

		camlp4 = overrideAll (impl: {
			# camlp4 uses +camlp4 directory, but when installed individually it's just
			# ../ocaml/camlp4
			configurePhase = ''
				find . -name META.in | while read f; do
					sed -i -e 's|"+|"../ocaml/|' "$f"
				done
				'';
			nativeBuildInputs = impl.nativeBuildInputs ++ [ which ];
			# see https://github.com/NixOS/nixpkgs/commit/b2a4eb839a530f84a0b522840a6a4cac51adcba1
			# if we strip binaries we can get weird errors such that:
			# /nix/store/.../bin/camlp4orf not found or is not a bytecode executable file
			# when executing camlp4orf
			dontStrip = true;
		}) opamPackages.camlp4;

		ctypes =
		let
			base =
				overrideAll (impl: {
					nativeBuildInputs = impl.nativeBuildInputs ++ [ pkgconfig libffi ncurses ];
				}) opamPackages.ctypes;
			withHeaderPatch =
			overrideIf (version: lib.elem version [
				# hardcode recent versions prior to https://github.com/ocamllabs/ocaml-ctypes/pull/557
				"0.11.4"
				"0.11.5"
				"0.12.0"
				"0.12.1"
				"0.13.0"
				"0.13.1"
			]) (addPatches [./ctypes/install-headers-once.patch]) base;
		in withHeaderPatch;

		gmp-xen = overrideAll (impl: {
			# this is a plain C lib
			configurePhase = "unset OCAMLFIND_DESTDIR";
		}) opamPackages.gmp-xen;

		lablgtk = overrideAll (impl: {
			nativeBuildInputs = impl.nativeBuildInputs ++ [ pkgconfig gtk2.dev ];
		}) opamPackages.lablgtk;

		llvm = overrideAll (impl: {
			nativeBuildInputs = impl.nativeBuildInputs ++ [ pkgconfig python ];
			propagatedBuildInputs = impl.propagatedBuildInputs ++ [ llvm_5 ];
			installPhase = ''
				bash -ex install.sh ${llvm_5}/bin/llvm-config $out/lib ${cmake}/bin/cmake make
				'';
		}) opamPackages.llvm;

		lwt = overrideAll (impl: {
			nativeBuildInputs = impl.nativeBuildInputs ++ [ ncurses ];
			setupHook = writeText "setupHook.sh" ''
				export LD_LIBRARY_PATH="$(dirname "$(dirname ''${BASH_SOURCE[0]})")/lib/lwt''${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
			'';
		}) opamPackages.lwt;

		nocrypto = disableStackProtection opamPackages.nocrypto;
		ocamlfind = overrideAll ((import ./ocamlfind) self) opamPackages.ocamlfind;
		ocb-stubblr = patchAll [./ocb-stubblr/optional-opam.diff] opamPackages.ocb-stubblr; # https://github.com/pqwy/ocb-stubblr/pull/10

		# fallout of https://github.com/ocaml/opam-repository/pull/6657
		omake = addNcurses opamPackages.omake;

		piqilib = overrideAll (impl: {
			nativeBuildInputs = impl.nativeBuildInputs ++ [ which makeWrapper ];
			# hack -- for some reason the makefile system ignores OCAMLPATH.
			configurePhase = ''
				mkdir .bin
				makeWrapper $(which ocamlfind) .bin/ocamlfind --prefix OCAMLPATH : "$OCAMLPATH"
				export PATH=$(readlink -f .bin):$PATH
			''+impl.configurePhase;
		}) opamPackages.piqilib;

		solo5-kernel-vertio = disableStackProtection opamPackages.solo5-kernel-vertio;
		solo5-kernel-ukvm = disableStackProtection opamPackages.solo5-kernel-ukvm;

		zarith = overrideAll (impl: {
			nativeBuildInputs = impl.nativeBuildInputs ++ [ perl ];
			configurePhase = ''
				patchShebangs .
			''+impl.configurePhase;
		}) opamPackages.zarith;

		zarith-xen = overrideAll (impl: {
			buildPhase = "${pkgs.bash}/bin/bash ${./zarith-xen/install.sh}";
			installPhase = "true";
		}) opamPackages.zarith-xen;
	};
}
