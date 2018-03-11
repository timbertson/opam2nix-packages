world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      alcotest = opamSelection.alcotest or null;
      astring = opamSelection.astring;
      benchmark = opamSelection.benchmark or null;
      camlzip = opamSelection.camlzip;
      jbuilder = opamSelection.jbuilder;
      ocaml = opamSelection.ocaml;
      ocamlfind = opamSelection.ocamlfind or null;
      ocplib-endian = opamSelection.ocplib-endian;
      odoc = opamSelection.odoc or null;
      qcheck = opamSelection.qcheck or null;
      rresult = opamSelection.rresult;
    };
    opamSelection = world.opamSelection;
    pkgs = world.pkgs;
in
pkgs.stdenv.mkDerivation 
{
  buildInputs = inputs;
  buildPhase = "${opam2nix}/bin/opam2nix invoke build";
  configurePhase = "true";
  installPhase = "${opam2nix}/bin/opam2nix invoke install";
  name = "ezgzip-0.2.1";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "ezgzip";
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
    sha256 = "1x85qjngwfr40am2mwfpxz7mrl55cr03ws7bx5b6d5b49jplc80h";
    url = "https://github.com/hcarty/ezgzip/archive/v0.2.1.tar.gz";
  };
}

