world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([ (pkgs.time or null) ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      async = opamSelection.async or null;
      base-bytes = opamSelection.base-bytes;
      lwt = opamSelection.lwt or null;
      ocaml = opamSelection.ocaml;
      ocamlfind = opamSelection.ocamlfind;
      ocplib-endian = opamSelection.ocplib-endian;
      ppx_tools = opamSelection.ppx_tools or null;
      sexplib = opamSelection.sexplib;
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
  name = "cstruct-2.2.0";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "cstruct";
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
    sha256 = "1q8phbjifl3lvapxsxlfwavwqs3zvkvxzgix296p12hs2dlm8q4x";
    url = "https://github.com/mirage/ocaml-cstruct/archive/v2.2.0.tar.gz";
  };
}

