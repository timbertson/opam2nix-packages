world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([ (pkgs.libxen-dev or null) ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      cmdliner = opamSelection.cmdliner;
      lwt = opamSelection.lwt;
      ocaml = opamSelection.ocaml;
      ocamlbuild = opamSelection.ocamlbuild;
      ocamlfind = opamSelection.ocamlfind;
      ounit = opamSelection.ounit;
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
  name = "xen-evtchn-1.0.7";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "xen-evtchn";
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
    sha256 = "0lm7j4zbmzr2zv3hpj7wi97cib16wvpidqw18gryz5kc2ipkmby1";
    url = "https://github.com/mirage/ocaml-evtchn/archive/v1.0.7.tar.gz";
  };
}

