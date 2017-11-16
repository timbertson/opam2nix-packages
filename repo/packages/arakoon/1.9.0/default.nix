world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([ (pkgs.help2man or null) ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      bisect = opamSelection.bisect or null;
      camlbz2 = opamSelection.camlbz2;
      camltc = opamSelection.camltc;
      conf-libev = opamSelection.conf-libev;
      core = opamSelection.core;
      lwt = opamSelection.lwt;
      ocaml = opamSelection.ocaml;
      ocamlbuild = opamSelection.ocamlbuild;
      ocamlfind = opamSelection.ocamlfind;
      ocplib-endian = opamSelection.ocplib-endian;
      quickcheck = opamSelection.quickcheck;
      redis = opamSelection.redis;
      sexplib = opamSelection.sexplib;
      snappy = opamSelection.snappy;
      ssl = opamSelection.ssl;
      uri = opamSelection.uri;
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
  name = "arakoon-1.9.0";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "arakoon";
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
    sha256 = "10a0yavi84w9yss56jd54z2nkild7a8ri8g8d3dbwx6lh17hxch3";
    url = "https://github.com/openvstorage/arakoon/archive/1.9.0.tar.gz";
  };
}

