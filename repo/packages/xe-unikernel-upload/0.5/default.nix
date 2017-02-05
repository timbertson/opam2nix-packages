world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      cmdliner = opamSelection.cmdliner;
      cstruct = opamSelection.cstruct;
      fat-filesystem = opamSelection.fat-filesystem;
      io-page = opamSelection.io-page;
      lwt = opamSelection.lwt;
      mbr-format = opamSelection.mbr-format;
      mirage-types = opamSelection.mirage-types;
      ocaml = opamSelection.ocaml;
      ocamlbuild = opamSelection.ocamlbuild;
      ocamlfind = opamSelection.ocamlfind;
      xen-api-client = opamSelection.xen-api-client;
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
  name = "xe-unikernel-upload-0.5";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "xe-unikernel-upload";
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
    sha256 = "0fw650j8d9p049zcpqwlx2miclp6m2ml4hl8v6q1b3jn5dcswg50";
    url = "https://github.com/djs55/xe-unikernel-upload/archive/v0.5.tar.gz";
  };
}

