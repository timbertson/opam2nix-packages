world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      conf-pkg-config = opamSelection.conf-pkg-config;
      cstruct = opamSelection.cstruct;
      io-page = opamSelection.io-page;
      logs = opamSelection.logs;
      lwt = opamSelection.lwt;
      minios-xen = opamSelection.minios-xen;
      mirage-clock-freestanding = opamSelection.mirage-clock-freestanding;
      mirage-profile = opamSelection.mirage-profile;
      mirage-xen-minios = opamSelection.mirage-xen-minios;
      mirage-xen-ocaml = opamSelection.mirage-xen-ocaml;
      ocaml = opamSelection.ocaml;
      ocamlbuild = opamSelection.ocamlbuild;
      ocamlfind = opamSelection.ocamlfind;
      shared-memory-ring = opamSelection.shared-memory-ring;
      xen-evtchn = opamSelection.xen-evtchn;
      xen-gnt = opamSelection.xen-gnt;
      xenstore = opamSelection.xenstore;
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
  name = "mirage-xen-3.0.0";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "mirage-xen";
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
    sha256 = "0idxk82dhwacky1w9hj7vblraq6xqg845zbxl86f7pg106y49hjp";
    url = "https://github.com/mirage/mirage-platform/archive/v3.0.0.tar.gz";
  };
}

