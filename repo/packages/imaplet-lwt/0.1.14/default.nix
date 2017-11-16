world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      cohttp = opamSelection.cohttp;
      dns = opamSelection.dns;
      fieldslib = opamSelection.fieldslib;
      git = opamSelection.git;
      irmin = opamSelection.irmin;
      irmin-unix = opamSelection.irmin-unix;
      lwt = opamSelection.lwt;
      menhir = opamSelection.menhir;
      nocrypto = opamSelection.nocrypto;
      ocaml = opamSelection.ocaml;
      ocamlbuild = opamSelection.ocamlbuild;
      ocamlfind = opamSelection.ocamlfind;
      re = opamSelection.re;
      tls = opamSelection.tls;
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
  name = "imaplet-lwt-0.1.14";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "imaplet-lwt";
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
    sha256 = "01yzmb4563n34q7zq1q4ccldavwzcx3drqh0pz9nagxwhpn6bs68";
    url = "https://github.com/gregtatcam/imaplet-lwt/archive/v0.1.14.tar.gz";
  };
}

