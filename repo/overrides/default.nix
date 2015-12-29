{self, super}:
with self.pkgs;
with lib;
let
	overrideAll = fn: versions: mapAttrs (version: def: lib.overrideDerivation def fn) versions;

	# XXX it's not really a `configure` phase, is it?
	addBinDir = def: overrideAll (impl: { configurePhase = ''mkdir -p $out/bin''; }) def;
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

		# TODO: should this be automated?
		biniou = addBinDir opamPackages.biniou;
		yojson = addBinDir opamPackages.yojson;
		fat-filesystem = addBinDir opamPackages.fat-filesystem;
	};
}
