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
      cstruct = opamSelection.cstruct;
      ctypes = opamSelection.ctypes;
      ctypes-foreign = opamSelection.ctypes-foreign;
      lwt = opamSelection.lwt;
      nocrypto = opamSelection.nocrypto;
      ocaml = opamSelection.ocaml;
      ocamlbuild = opamSelection.ocamlbuild;
      ocamlfind = opamSelection.ocamlfind;
      ocplib-endian = opamSelection.ocplib-endian;
      quickcheck = opamSelection.quickcheck;
      sexplib = opamSelection.sexplib;
      snappy = opamSelection.snappy;
      ssl = opamSelection.ssl;
      uuidm = opamSelection.uuidm;
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
  installPhase = "${opam2nix}/bin/opam2nix invoke install";
  name = "arakoon-1.8.11";
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
    sha256 = "1sziw3qrmqrwkwh8fzr1aiw1rml3162184jcbb4wwigf03npx4pg";
    url = "https://github.com/openvstorage/arakoon/archive/1.8.11.tar.gz";
  };
}

