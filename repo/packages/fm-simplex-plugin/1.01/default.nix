world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      alt-ergo = opamSelection.alt-ergo;
      ocaml = opamSelection.ocaml;
      ocamlfind = opamSelection.ocamlfind or null;
      zarith = opamSelection.zarith;
    };
    opamSelection = world.opamSelection;
    pkgs = world.pkgs;
in
pkgs.stdenv.mkDerivation 
{
  buildInputs = inputs;
  buildPhase = "${opam2nix}/bin/opam2nix invoke build";
  configurePhase = "true";
  createFindlibDestdir = true;
  installPhase = "${opam2nix}/bin/opam2nix invoke install";
  name = "fm-simplex-plugin-1.01";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "fm-simplex-plugin";
    ocaml-version = world.ocamlVersion;
    spec = ./opam;
  };
  passthru = 
  {
    opamSelection = opamSelection;
  };
  propagatedBuildInputs = inputs;
  src = fetchurl 
  {
    sha256 = "1sw0ybmzpyrg55rrq2sqal1rapxppvlh9plc81sx8rgjmhrrh6nm";
    url = "http://alt-ergo.ocamlpro.com/http/alt-ergo-1.01/alt-ergo-1.01.tar.gz";
  };
}

