world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      base64 = opamSelection.base64;
      cmdliner = opamSelection.cmdliner;
      cohttp = opamSelection.cohttp;
      core_kernel = opamSelection.core_kernel;
      ezjsonm = opamSelection.ezjsonm;
      fieldslib = opamSelection.fieldslib;
      lwt = opamSelection.lwt;
      magic-mime = opamSelection.magic-mime;
      ocaml = opamSelection.ocaml;
      ocamlfind = opamSelection.ocamlfind;
      omake = opamSelection.omake;
      re = opamSelection.re;
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
  name = "opium-0.14.0";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "opium";
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
    sha256 = "02j1w5cxx4fyw83l0mgibyfz0wnnr0msd3b2x6vcxisvsdhvmsz1";
    url = "https://github.com/rgrinberg/opium/archive/v0.14.0.tar.gz";
  };
}

