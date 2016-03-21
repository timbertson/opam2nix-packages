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
      lwt = opamSelection.lwt;
      ocaml = opamSelection.ocaml;
      ocamlbuild = opamSelection.ocamlbuild;
      ocamlfind = opamSelection.ocamlfind;
      ocplib-endian = opamSelection.ocplib-endian;
      quickcheck = opamSelection.quickcheck;
      sexplib = opamSelection.sexplib;
      snappy = opamSelection.snappy;
      ssl = opamSelection.ssl;
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
  name = "arakoon-1.8.12";
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
    sha256 = "06vpcal110k5ix5kb6l2206sxmp3x8xj6cx54q8whbp0pbw8d091";
    url = "https://github.com/openvstorage/arakoon/archive/1.8.12.tar.gz";
  };
}

