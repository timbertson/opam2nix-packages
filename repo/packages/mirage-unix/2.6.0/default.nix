world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      conf-which = opamSelection.conf-which;
      cstruct = opamSelection.cstruct;
      io-page = opamSelection.io-page;
      lwt = opamSelection.lwt;
      mirage-clock-unix = opamSelection.mirage-clock-unix;
      mirage-profile = opamSelection.mirage-profile;
      ocaml = opamSelection.ocaml;
      ocamlbuild = opamSelection.ocamlbuild;
      ocamlfind = opamSelection.ocamlfind;
      shared-memory-ring = opamSelection.shared-memory-ring;
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
  name = "mirage-unix-2.6.0";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "mirage-unix";
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
    sha256 = "1qp5sbw5x8ma3rm3pg1wa93ik5bz93qn8jzl748dc7zj6fxqa6mr";
    url = "https://github.com/mirage/mirage-platform/archive/v2.6.0.tar.gz";
  };
}

