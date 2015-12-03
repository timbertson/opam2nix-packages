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

		cstruct = overrideAll (impl: {
			installPhase = "make install JS_DEST=$OCAMLFIND_DESTDIR";
		}) opamPackages.cstruct;

		gmp-xen = overrideAll (impl: {
			# this is a plain C lib
			configurePhase = "unset OCAMLFIND_DESTDIR";
		}) opamPackages.gmp-xen;

		zarith-xen = overrideAll (impl: {
			buildPhase = "${pkgs.bash}/bin/bash ${./zarith-xen}/install.sh";
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
