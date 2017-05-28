world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([ (pkgs.help2man or null) ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      camlbz2 = opamSelection.camlbz2;
      camltc = opamSelection.camltc;
      conf-libev = opamSelection.conf-libev;
      core = opamSelection.core;
      lwt = opamSelection.lwt;
      lwt_ssl = opamSelection.lwt_ssl;
      ocaml = opamSelection.ocaml;
      ocamlbuild = opamSelection.ocamlbuild;
      ocamlfind = opamSelection.ocamlfind;
      ocplib-endian = opamSelection.ocplib-endian;
      quickcheck = opamSelection.quickcheck;
      redis = opamSelection.redis;
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
  name = "arakoon-1.9.17";
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
    sha256 = "1jgambgfdp04df6kiqwb1mcks6z0pifhxdiq778vrkdbl5q8g03s";
    url = "https://github.com/openvstorage/arakoon/archive/1a5da78cd06e7662c6d262ae0c723c4d54d94542.tar.gz";
  };
}

